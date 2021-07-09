Quatauta's dotfiles
===================

My collection of dotfiles for Linux, mostly used on Gentoo/Linux systems. The dotfiles are
managed with [thoughtbot's rcm](https://github.com/thoughtbot/rcm).

Setup
-----

To use all these dotfiles files:

1. Install [thoughtbot's rcm](https://github.com/thoughtbot/rcm)
   * `sudo apt-get install rcm` on Ubuntu
   * `pikaur -S rcm` on Arch Linux with [pikaur](https://github.com/actionless/pikaur) for [rcm from AUR](https://aur.archlinux.org/packages/rcm/)
   * `brew install rcm` with Brew on maxOS or Linux
1. Clone this repository
   * `git clone https://github.com/quatauta/dotfiles.git $HOME/.dotfiles`
1. Symlink [rcm configuration](rcrc) to `~/.rcrc`
   * `ln -sv ~/.dotfiles/rcrc ~/.rcrc`
1. List the dotfiles in `~/.dotfiles` and their locations in `~/`/`${HOME}/` (optional, but recommended)
   * `lsrc -F`
1. Symlink the dotfiles to `~/`
   *  `rcup`
```
