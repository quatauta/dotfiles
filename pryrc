# ~/.pryrc
# vim:syntax=ruby:

Pry.config.theme = "railscasts"

begin
  require "amazing_print"
  require "did_you_mean"
rescue
end
