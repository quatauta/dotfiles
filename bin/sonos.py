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

from __future__ import print_function
import argparse
import soco

# IP address of your speaker.
DEVICE_ADDRESS = '10.0.0.11'

def mk_parser(subparsers, name, func):
    parser = subparsers.add_parser(name)
    parser.set_defaults(func=func)
    return parser

def parser(device):
    parser     = argparse.ArgumentParser()
    subparsers = parser.add_subparsers()
    parser.set_defaults(dev=device)
    mk_parser(subparsers, 'crossfade', crossfade)
    mk_parser(subparsers, 'help', lambda a: parser.print_help())
    mk_parser(subparsers, 'mute', mute)
    mk_parser(subparsers, 'next', lambda a: a.dev.next())
    mk_parser(subparsers, 'pause', pause)
    mk_parser(subparsers, 'play', play).add_argument('track_no', metavar='N', type=int, nargs='?', help='Queue track number to play (0-based)')
    mk_parser(subparsers, 'previous', lambda a: a.dev.previous())
    mk_parser(subparsers, 'queue', queue)
    mk_parser(subparsers, 'repeat', repeat)
    mk_parser(subparsers, 'shuffle', shuffle)
    mk_parser(subparsers, 'status', status)
    mk_parser(subparsers, 'volume', volume).add_argument('volume', metavar='+/-', choices=('+', '-'), nargs='?', help='Increase ("+") or decrese ("-") volume level')
    return parser

def crossfade(args):
    args.dev.cross_fade = not args.dev.cross_fade
    print(args.dev.cross_fade)

def mute(args):
    args.dev.mute = not args.dev.mute
    print(args.dev.mute)

def play(args):
    if args.track_no is None:
        args.dev.play()
    else:
        args.dev.play_from_queue(args.track_no)

def repeat(args):
    states = { 'NORMAL':           False,
               'SHUFFLE_NOREPEAT': False,
               'REPEAT_ALL':       True,
               'SHUFFLE':          True, }
    transitions = { 'NORMAL':           'REPEAT_ALL',
                    'REPEAT_ALL':       'NORMAL',
                    'SHUFFLE_NOREPEAT': 'SHUFFLE',
                    'SHUFFLE':          'SHUFFLE_NOREPEAT', }
    args.dev.play_mode = transitions[args.dev.play_mode]
    print(states[args.dev.play_mode])

def pause(args):
    if args.dev.get_current_transport_info()['current_transport_state'] == 'PAUSED_PLAYBACK':
        args.dev.play()
    else:
        args.dev.pause()

def queue(args):
    QUEUE_FMT = '{pos:3}. {artist} - {title}'
    for pos, track in enumerate(args.dev.get_queue()):
        print(QUEUE_FMT.format(pos=pos, **track))

def shuffle(args):
    states = { 'NORMAL':           False,
               'REPEAT_ALL':       False,
               'SHUFFLE_NOREPEAT': True,
               'SHUFFLE':          True, }
    transitions = { 'NORMAL':           'SHUFFLE_NOREPEAT',
                    'SHUFFLE_NOREPEAT': 'NORMAL',
                    'SHUFFLE':          'REPEAT_ALL',
                    'REPEAT_ALL':       'SHUFFLE', }
    args.dev.play_mode = transitions[args.dev.play_mode]
    print(states[args.dev.play_mode])

def status(args):
    STATUS_FMT = '''\
{artist} - {title}
{album}
{position} - {duration}, pos {playlist_position}, vol {vol}, {state}\
'''
    print(STATUS_FMT.format(vol = args.dev.volume,
                            state = (args.dev.get_current_transport_info()['current_transport_state'] +
                                     ', ' + args.dev.play_mode +
                                     (', CROSSFADE' if args.dev.cross_fade else '')).lower(),
                            **args.dev.get_current_track_info()))

def volume(args):
    MAX_VOLUME = 70
    if args.volume is not None:
        vol = args.dev.volume + (3 if args.volume == '+' else -3)
        args.dev.volume = min(vol, MAX_VOLUME)
    print(args.dev.volume)

if __name__ == '__main__':
    device = soco.SoCo(DEVICE_ADDRESS)
    parser = parser(device)
    args   = parser.parse_args()

    if hasattr(args, 'func'):
        args.func(args)
    else:
        status(args)

# EOF
