# ~/.pryrc
# vim:syntax=ruby:

Pry.config.history.file = "~/.cache/pry-history"
Pry.config.theme = "railscasts"

begin
  require 'did_you_mean'
rescue
end
