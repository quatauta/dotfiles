#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'pp'

def passwords(options)
  options = {
    :parameters => [ :c, :n, :B, :y ],
    :length     => 14,
    :number     =>  1
  }.merge(options)
  
  options[:parameters] = options[:parameters].map { |s|
                           s.to_s[0..0]
                         }.select { |s|
                           /^[a-zA-Z0-9]$/ =~ s
                         }
  options[:length] = options[:length].to_i
  options[:number] = options[:number].to_i

  cmd = "pwgen -%s %d %d" % [ options[:parameters].join(""),
                              options[:length],
                              options[:number] ]

  passwords = %x{#{cmd}}.split
end

def rate(passwords)
  bad   = 'zZyYäÄöÖüÜ^°"§&/=ß?´`({[]})@€+*~#<>|;:_\'\\\\-'
  left  = ' ' + '^123456' + 'qwert' + 'asdfg' + '<yxcv' +
                '°!"§$%&' + 'QWERT' + 'ASDFG' + '>YXCV'
  right = '7890ß´' + 'zuiopü+' + 'hjklöä#' + 'bnm,.-' +
          '/()=?`' + 'ZUIOPÜ*' + "HJKLÖÄ'" + 'BNM;:_'
  
  passwords.reject { |password|
    password.count(bad) > 0
  }.map { |password|
    left_only    = password.gsub(Regexp.new('[%s]' % [right], Regexp::IGNORECASE), ' ')
    left_blocks  = left_only.split.size
    right_only   = password.gsub(Regexp.new('[%s]' % [left] , Regexp::IGNORECASE), ' ')
    right_blocks = right_only.split.size
    hand_changes = left_blocks + right_blocks - 1
    score        = hand_changes

    [ score, password ]
  }
end

def print(scored_passwords = [])
  puts "Score  Password"
  puts "-----  --------"

  scored_passwords.each { |arr|
    score, password = arr
    puts"%5d  %s" % [ score, password ]
  }

  nil
end

number    = 1000
passwords = passwords(:number => number)
rated     = rate(passwords).sort { |a, b| b.first <=> a.first }

puts "The 20 of #{number} best left-right-distributed passwords:"
print(rated[0..20])
