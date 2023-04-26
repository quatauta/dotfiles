#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "command_kit", "~>0.4"
  # gem "git", "~>1.18"
  gem "pastel", "~>0.8"
  gem "tty-command", "~>0.10"
  gem "tty-spinner", "~>0.9"
end

require "command_kit/xdg"

module UpdateDependencies
  module CLI
    class Cmd < CommandKit::Command
      include CommandKit::XDG

      command_name File.basename(__FILE__, ".rb")
      usage "[OPTIONS] [DIRECTORY...]"
      description [
        "Update the dependencies of your local git repositories, commit the changes in new git branch, create a pull/merge request, and merge.",
        "",
        "If your repository has executable bin/update-dependencies, I will start this executable.",
        "",
        "If your repository has no executable bin/update-dependencies, I will update:",
        "- asdf tool versions (https://asdf-vm.com)",
        "- Elixir mix packages (https://hexdocs.pm/mix/Mix.html)",
        "- Ruby Bundler Gemfile (https://bundler.io)",
        "- JavaScript npm packages (https://www.npmjs.com/) using npm (https://docs.npmjs.com/cli) or yarn (https://yarnpkg.com)"
      ]

      option(:find, short: "-f", category: "Find options", desc: "Find git repositories in each DIRECTORY")
      option(:maxdepth, short: "-d", category: "Find options", desc: "Maximum sub-path depth to search git repositories", value: {type: Integer, usage: "DEPTH"})
      option(:exclude, short: "-x", category: "Find options", desc: "Exclude git repositories matching this Ruby regular expression", value: {type: Regexp, usage: "REGEX"})
      option(:git_commit, short: "-c", category: "Git commit options", desc: "Add changes to a new git branch")
      option(:gitlab_mr, short: "-m", category: "Git commit options", desc: "Create GitLab merge request")
      option(:dry_run, short: "-n", desc: "Do not run any commands")
      option(:fail_fast, short: "-F", desc: "Stop if updating dependencies fails")
      option(:printer, short: "-p", desc: "Command progress formatter: pretty, spinner, progress, quiet, null", value: {type: {"pretty": :pretty, "spinner": :spinner, "progress": :progress, "quiet": :quiet, "null": :null}})
      argument(:directory, repeats: true, required: true, usage: "DIRECTORY", desc: "Directories to search git repositories")
      examples(["~/work/"])

      def initialize(**kwargs)
        super(**kwargs)
      end

      def run(*directories)
        directories = GitRepoLocator.new(directories).locate(maxdepth: options[:maxdepth], exclude: options[:exclude]) if options[:find]
        directories.select! { |directory| File.directory? directory }
        Updater.new(directories, options).run
      end
    end
  end

  class GitRepoLocator
    def initialize(directories)
      @directories = directories || []
    end

    def locate(maxdepth: nil, exclude: nil)
      @directories.map { |directory|
        git_configs = Pathname(directory).glob("**/.git/config")
        git_configs.select! { |path| path.relative_path_from(directory).to_s.split("/").length <= maxdepth + 2 } if maxdepth
        git_configs.reject! { |path| path.to_s =~ exclude } if exclude
        git_configs.map { |path| path.dirname.dirname }
      }.flatten
    end
  end

  class Updater
    # git commit 🏷
    # git branch 
    UPDATERS = [
      {files: [".git/config"], commands: {
        "store branch names": 'git branch --show-current >.git/update-dependencies-pre-branch ; echo "dependencies/$(date -u "+%F-%H-%M-%S%z")" >.git/update-dependencies-new-branch',
        "stash push": 'if [[ -n "$(git ls-files --modified --others)" ]] ; then git stash push --quiet --all --include-untracked --message "update-dependencies git stash push $(date -u "+%F %T%z")"; fi',
        "checkout default branch": 'git checkout --quiet "$((git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || git symbolic-ref --short HEAD) | sed -E \'s_[^/]+/__\')"'
      }},
      {files: ["Brewfile.lock.json"], commands: {"brew bundle install": "brew bundle install"}},
      {files: [".tool-versions"], commands: {"asdf install": "asdf install", "asdf-missing update": "asdf-missing update"}},
      {files: ["mix.lock"], commands: {"mix local.hex": "mix local.hex --force --if-missing", "mix local.rebar": "mix local.rebar --force --if-missing", "mix deps.update": "mix deps.update --all"}},
      {files: ["Gemfile.lock"], commands: {"bundle update": "bundle update --all"}},
      {files: ["package.lock", "npm-shrinkwrap.json"], commands: {"npm update": "npm update"}},
      {files: ["yarn.lock"], commands: {"yarn upgrade": "yarn upgrade"}},
      {files: [".git/config"], commands: {
        "checkout new update branch": 'if [[ -n "$(git ls-files --modified)" ]] ; then git checkout --quiet -b "$(cat .git/update-dependencies-new-branch)" ; fi',
        "push new branch with MR": 'if [[ -n "$(git ls-files --modified)" ]] && git remote | grep -q . ; then git push --quiet --prune --set-upstream --push-option merge_request.create --push-option merge_request.remove_source_branch origin HEAD ; fi',
        "commit and push changes": 'git ls-files --modified | while read -r FILE ; do git commit --quiet --message "Update dependencies - ${FILE}" -- "${FILE}" ; if git remote | grep -q . ; then git push --quiet origin HEAD ; fi ; done',
        "merge MR": 'if git rev-parse "$(cat .git/update-dependencies-new-branch)" &>/dev/null && git remote --verbose | grep -Fq gitlab.com ; then glab mr update --ready ; glab mr merge --yes --remove-source-branch --squash --when-pipeline-succeeds ; fi',
        "checkout default branch and pull": 'git checkout --quiet "$(cat .git/update-dependencies-pre-branch)" ; if git remote --verbose | grep -q . ; then git pull --quiet --autostash ; fi',
        "stash pop": "if git stash list | grep -q .; then git stash pop --index --quiet ; fi",
        "delete and forget branchs": 'if git rev-parse "$(cat .git/update-dependencies-new-branch)" &>/dev/null && [[ "$(git rev-parse "$(cat .git/update-dependencies-pre-branch)")" == "$(git rev-parse "$(cat .git/update-dependencies-new-branch)")" ]] ; then git branch --quiet -D "$(cat .git/update-dependencies-new-branch)" ; fi ; rm .git/update-dependencies-pre-branch .git/update-dependencies-new-branch'
      }}
    ]
    public_constant :UPDATERS

    attr_reader :directories, :printer

    def initialize(directories, options)
      @directories = directories
      @dry_run = options.fetch(:dry_run, false)
      @fail_fast = options.fetch(:fail_fast, false)
      @printer = options.fetch(:printer, :pretty)
    end

    def dry_run?
      @dry_run
    end

    def fail_fast?
      @fail_fast
    end

    def run
      directories.each do |directory|
        Dir.chdir(directory) do
          run_updaters(directory)
        end
      end
    end

    def run_updaters(directory)
      dir_spinner = TTY::Spinner::Multi.new("[:spinner] #{replace_home(directory)}",
        format: :dots, interval: 5,
        success_mark: Pastel.new.green(TTY::Spinner::TICK),
        error_mark: Pastel.new.bold.red(TTY::Spinner::CROSS))

      commands = UPDATERS.select { |updater| updater[:files].any? { |file| File.exist?(File.join(directory, file)) } }.inject({}) { |commands, updater| commands.merge(updater[:commands]) }
      spinners = []

      commands.each_with_index do |name_and_command, command_index|
        name, command = name_and_command
        if printer == :spinner
          spinners << dir_spinner.register("[:spinner] #{name}") do |spinner|
            spinners.each_with_index do |other_spinner, other_spinner_index|
              other_spinner.join if other_spinner_index < command_index
            end
            result = run_command(command, :null)
            message = "[%.2fs]" % [result.runtime]
            result.success? ? spinner.success(message) : spinner.error(message)
            exit result.exitstatus if fail_fast? && result.failure?
          end
        else
          result = run_command(directory, command, printer)
          exit result.exitstatus if fail_fast? && result.failure?
        end
      end

      dir_spinner.auto_spin unless spinners.empty?
    end

    def run_command(command, printer)
      result = TTY::Command.new(dry_run: dry_run?, printer: printer).run!(command)
      result
    end

    private

    def replace_home(path)
      path.to_s.sub(ENV["HOME"], "~")
    end
  end
end

UpdateDependencies::CLI::Cmd.start
