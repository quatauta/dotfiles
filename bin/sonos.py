#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Remote control for the Sonos sound system.
#
# Copyright (c) 2014, Matthias Friedrich <matt@mafr.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
from __future__ import print_function
import argparse
import soco

# Hostname or IP address of your speaker.
DEVICE_ADDRESS = '10.0.0.11'

# Speaker volume cutoff for safety :)
MAX_VOLUME = 70

QUEUE_FMT = '{pos:3}. {artist} - {title}'
STATUS_FMT = '''\
{artist} - {title}
{album}
{position} - {duration}, pos {playlist_position}, vol {vol}, {state}\
'''

def mk_parser(subparsers, name, funct):
    parser = subparsers.add_parser(name)
    parser.set_defaults(func=funct)
    return parser

def mute(args):
    args.dev.mute = not args.dev.mute

def play(args):
    if args.track_no is None:
        args.dev.play()
    else:
        args.dev.play_from_queue(args.track_no)

def pause(args):
    if args.dev.get_current_transport_info()['current_transport_state'] == 'PAUSED_PLAYBACK':
        args.dev.play()
    else:
        args.dev.pause()

def volume(args):
    if args.volume is not None:
        vol = args.dev.volume + (3 if args.volume == '+' else -3)
        args.dev.volume = min(vol, MAX_VOLUME)
    print(args.dev.volume)

def repeat(args):
    transitions = { 'NORMAL':           'REPEAT_ALL',
                    'REPEAT_ALL':       'NORMAL',
                    'SHUFFLE_NOREPEAT': 'SHUFFLE',
                    'SHUFFLE':          'SHUFFLE_NOREPEAT', }
    args.dev.play_mode = transitions[args.dev.play_mode]

def shuffle(args):
    transitions = { 'NORMAL':           'SHUFFLE_NOREPEAT',
                    'SHUFFLE_NOREPEAT': 'NORMAL',
                    'SHUFFLE':          'REPEAT_ALL',
                    'REPEAT_ALL':       'SHUFFLE', }
    args.dev.play_mode = transitions[args.dev.play_mode]

def crossfade(args):
    args.dev.cross_fade = not args.dev.cross_fade

def status(args):
    print(STATUS_FMT.format(vol = args.dev.volume,
                            state = args.dev.get_current_transport_info()['current_transport_state'],
                            **args.dev.get_current_track_info()))

def queue(args):
    for pos, track in enumerate(args.dev.get_queue()):
        print(QUEUE_FMT.format(pos=pos, **track))


parser = argparse.ArgumentParser()
subparsers = parser.add_subparsers()
mk_parser(subparsers, 'queue', queue)
mk_parser(subparsers, 'status', status)
mk_parser(subparsers, 'next', lambda a: a.dev.next())
mk_parser(subparsers, 'previous', lambda a: a.dev.previous())
mk_parser(subparsers, 'pause', pause)
mk_parser(subparsers, 'mute', mute)
mk_parser(subparsers, 'repeat', repeat)
mk_parser(subparsers, 'shuffle', shuffle)
mk_parser(subparsers, 'crossfade', crossfade)

parser_play = subparsers.add_parser('play')
parser_play.add_argument('track_no', metavar='N', type=int, nargs='?',
                        help='Queue track number to play (0-based)')
parser_play.set_defaults(func=play)

parser_volume = subparsers.add_parser('volume')
parser_volume.add_argument('volume', metavar='X', choices=('+', '-'), nargs='?',
                        help='Increase ("+") or decrese ("-") volume level')
parser_volume.set_defaults(func=volume)

if __name__ == '__main__':
    device = soco.SoCo(DEVICE_ADDRESS)
    parser.set_defaults(dev=device)
    args = parser.parse_args()
    args.func(args)

# EOF
