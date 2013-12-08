# ~/.irbrc
# vim:syntax=ruby sw=2 sts=2:

require 'awesome_print'
require 'irbtools'
require 'irb/ext/save-history'
require 'bond'

Bond.start
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
IRB.conf[:SAVE_HISTORY] = 1000
