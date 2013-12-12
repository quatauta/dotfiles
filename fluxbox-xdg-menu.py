#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# vim: noexpandtab:ts=8:sts=4:sw=4

"""Menu Generator for Fluxbox

Generates a menu for Fluxbox using the freedesktop.org standards

Usage: fluxbox-fdo-menugen.py [options]

Options:
  -l ..., --lang=...   create the menu using a language. Default = $LANG
  -h, --help           show this help
  -f ..., --file=...   output the menu into a file. Default = ~/.fluxbox/menu
  -t ..., --theme=...  what icon theme you want to use
  --with-icons         do not put icons for applications in the menu
  --stdout             output the menu to standard output
  --submenu            output to be used as an include/submenu with fluxbox
  --with-backgrounds   creates a background menu. Default background_paths =
                       ~/.fluxbox/backgrounds, /usr/share/wallpapers,
                       /usr/share/backgrounds
  --backgrounds-only   do not regenerate menu, only do the bg menu.
  --bg-path=           path to location to look for images
                       example: --bg-path=~/pics
                       may be used with --backgrounds-only but --bg-path=
                       must be first: --bg-path=~/some/path --backgrounds-only

A nice example string to use: fluxbox-fdo-menugen.py --with-icons --with-backgrounds --bg-path=~/some/path
To update only the backgrounds: fluxbox-fdo-menugen.py --bg-path=~/some/path --backgrounds-only
"""

__author__  = "Rudolf Kastl, Antonio Gomes, Michael Rice"
__version__ = "$Revision: 1.2 $"
__date__    = "$Date: 2006/10/09 23:20:10 $"
__license__ = "GPL"


import getopt
import glob
import os
import re
import sys
import xdg.DesktopEntry
import xdg.IconTheme
import xdg.Menu

from os.path import isfile
from xdg.Exceptions import *

def usage():
    print __doc__

def indent(depth = 1):
    return depth * "  "

def header(wm = "fluxbox"):
    return (indent(0) + "[begin] (Fluxbox)\n" +
            indent(1) +   "[exec] (Terminal) {xterm}\n" +
            indent(1) +   "[exec] (Nemo)     {nemo --no-desktop}\n" +
            indent(1) +   "[exec] (Opera)    {opera}\n" +
            indent(1) +   "[exec] (Firefox)  {firefox}\n" +
            indent(1) +   "[exec] (Liferea)  {liferea}\n" +
            indent(1) +   "[exec] (Sonos)    {sonos}\n" +
            indent(1) +   "[exec] (Gmrun)    {gmrun}\n" +
            indent(1) +   "[separator]")

def footer(wm = "fluxbox"):
    return (indent(1) +   "[separator]\n" +
            indent(1) +   "[submenu] (Fluxbox)\n" +
            indent(2) +     "[config] (Configure)\n" +
            indent(2) +     "[submenu] (System Styles) {Choose a style...}\n" +
            indent(3) +       "[stylesdir] (/usr/share/fluxbox/styles)\n" +
            indent(3) +       "[stylesdir] (/usr/share/commonbox/styles/)\n" +
            indent(2) +     "[end]\n" +
            indent(2) +     "[submenu] (User Styles) {Choose a style...}\n" +
            indent(3) +       "[stylesdir] (~/.fluxbox/styles)\n" +
            indent(2) +     "[end]\n" +
            indent(2) +     "[workspaces]   (Workspace List)\n" +
            indent(2) +     "[submenu] (Tools)\n" +
            indent(3) +       "[exec] (Window Name) {zenity --info " +
				     "--title='X Window Properties' " +
				     "--text=\"Identifing properties of the selected window:  \\n\\n" +
				     "<tt>" +
				     "$(xprop | grep '^WM_\(CLASS\|NAME\|WINDOW_ROLE\)')" +
				     "</tt>\"}\n" +
            indent(3) +       "[exec] (Screenshot) {import -border -frame " +
                                     "\"$HOME/Documents/_temp/screen_`date " +
                                     "+%Y-%m-%d_%H:%M:%S%:z`.png\"}\n" +
            indent(3) +       "[exec] (Run) {gmrun}\n" +
            indent(2) +     "[end]\n" +
            indent(2) +     "[submenu] (Window Manager)\n" +
            indent(3) +       "[restart] (Fluxbox) {fluxbox}\n" +
            indent(3) +       "[restart] (Cinnamon) {cinnamon}\n" +
            indent(2) +     "[end]\n" +
            indent(2) +     "[exec] (Lock screen) {xdg-screensaver lock}\n" +
            indent(2) +     "[commanddialog] (Fluxbox Command)\n" +
            indent(2) +     "[reconfig] (Reload Config)\n" +
            indent(2) +     "[exec] (Regen Menu) {fluxbox-xdg-menu}\n" +
            indent(2) +     "[exec] (Info) {zenity --info --title='Fluxbox Info' --text=\"<tt>$(fluxbox -v; fluxbox -info | sed 1d 2>/dev/null)</tt>\"}\n" +
            indent(1) +   "[end]\n" +
            indent(1) +   "[exec] (Hibernate) {systemctl hybrid-sleep}\n" +
            indent(1) +   "[restart] (Restart Fluxbox)\n" +
            indent(1) +   "[exec] (Exit Fluxbox) {fluxbox-exit}\n" +
            indent(0) + "[end]")

def checkWm(entry, wm = "fluxbox"):
    if entry.DesktopEntry.getOnlyShowIn() != []:
        entry.Show = False

        if entry.DesktopEntry.getNotShowIn() != []:
            if isinstance(entry, xdg.Menu.MenuEntry):
                if wm in entry.DesktopEntry.getNotShowIn():
                    entry.Show = False
                else:
                    entry.Show = True

def findIcon(icon, theme):
    """Finds the path and filename for the given icon name
    e.g. gaim --> /usr/share/pixmaps/gaim.png
    e.g. fart.png --> /usr/share/pixmaps/fart.png
    """
    retval = str(xdg.IconTheme.getIconPath(icon, 48, theme))

    if retval == "None":
        retval = ""

    return (retval + "").encode('utf8')

def remove_wildcards(cmd):
    return re.sub(r'\s*%\w+', '', cmd)

def parseMenu(menu, wm, use_icons, theme, depth = 1):
    if use_icons:
        print "%s[submenu] (%s) <%s>" % (
            indent(depth),
            menu.getName().encode('utf8'),
            findIcon(menu.getIcon(), theme)
            )
    else:
        print "%s[submenu] (%s)" % (indent(depth),
                                    menu.getName().encode('utf8'))

    depth += 1

    for entry in menu.getEntries():
        if isinstance(entry, xdg.Menu.Menu):
            parseMenu(entry, wm, use_icons, theme, depth)
        elif isinstance(entry, xdg.Menu.MenuEntry):
            checkWm(entry, wm)

            if entry.Show == False:
                continue
            if "" == entry.DesktopEntry.getExec():
                continue
            if not exists_in_path(entry.DesktopEntry.getExec().split()[0]):
                continue

            if entry.DesktopEntry.getPath():
                cmd = "cd \"%s\" && %s" % \
                    (entry.DesktopEntry.getPath(),
                     remove_wildcards(entry.DesktopEntry.getExec()))
            else:
                cmd = remove_wildcards(entry.DesktopEntry.getExec())

            if entry.DesktopEntry.getTerminal():
                cmd = "xterm -e %s" % cmd

            name = entry.DesktopEntry.getName()
            name = re.sub(r'\)', r'\\)', name)

            if use_icons:
                print "%s[exec] (%s) {%s} <%s>" % \
                    (indent(depth), name, cmd,
                     findIcon(entry.DesktopEntry.getIcon(), theme))
            else:
                print ("%s[exec] (%s) {%s}" % \
                         (indent(depth), name, cmd)).encode('utf8')
        elif isinstance(entry, xdg.Menu.Separator):
            print "%s[separator]" % indent(depth)
        elif isinstance(entry.xdg.Menu.Header):
            print "%s%s" % (indent(depth), entry.Name)

    depth -= 1
    print "%s[end]" % indent(depth)

def exists_in_path(filename):
    exists = False

    if filename.startswith("/"):
        exists = os.path.exists(filename)
    else:
        for path in os.path.expandvars("${PATH}").split(":"):
            if os.path.exists(os.path.join(path, filename)):
                exists = True
                break

    return exists

def get_bgimgs_and_parse(xPath):
    try:
        if isfile(os.path.expanduser("~/.fluxbox/bgmenu")) == True:
            os.unlink(os.path.expanduser("~/.fluxbox/bgmenu"))
    except OSError:
        pass

    h = {}
    bg_paths = ["~/.fluxbox/backgrounds",
                "/usr/share/wallpapers",
                "/usr/share/backgrounds",
                "/usr/share/backgrounds/images"]

    try:
        if xPath == None:
            pass
        else:
            bg_paths.append(xPath)
    except(TypeError):
        pass

    for dir in bg_paths:
        for imgpth in bg_paths:
            try:
                imgs = os.listdir(os.path.expanduser(imgpth))
                for i in imgs:
                    h[i] = imgpth
            except (OSError):
                pass

    bgMenu   = open(os.path.expanduser("~/.fluxbox/bgmenu"), 'w+')
    num      = len(h)
    countNum = 1
    bgPagCk  = 1
    bgPgNum  = 1

    bgMenu.write("[submenu] (Backgrounds)\n")
    bgMenu.write(indent(1) + "[submenu] (Backgrounds) {Set Your Background}\n")
    bgMenu.write(indent(2) + "[exec]  (Random Image)  " +
                             "{fbsetbg -r ~/.fluxbox/backgrounds}\n")

    types = ["png", "jpg", "jpeg", "gif"]

    for i in h.keys():
        try:
            t = i.split(".")[-1].lower()
            if t in types:
                bgMenu.write(indent(2) + "[exec] (" + i + ") " +
                             "{fbsetbg -f " + h[i] + "/" + i + "}\n")

                countNum = countNum + 1
                num      = num - 1
                bgPagCk  = bgPagCk + 1

                if bgPagCk == 26:
                    bgPgNum = bgPgNum + 1
                    bgMenu.write(indent(1) + "[end]\n" +
                                 indent(1) + "[submenu] " +
                                 "(Backgrounds " + str(bgPgNum) + ") " +
                                 "{Set Your Background}\n")
                    bgPagCk = 1

                    if num == 0:
                        bgMenu.write(indent(1) + "[end]\n" +
                                     "[end]\n")
                        bgMenu.close()
        except(KeyError):
            print h[i]
            pass

def main(argv):
    wm         = "fluxbox"
    file       = "~/.fluxbox/menu"
    use_icons  = False
    use_bg     = False
    bg_Xpath   = False
    theme      = "gnome"
    lang       = os.getenv("LANG", "C")
    file       = os.path.expanduser("~/.fluxbox/menu")
    do_submenu = False
    use_stdout = False

    try:
        opts, args = getopt.getopt(argv, "hf:dl:d",
                                   ["help",
                                    "lang=",
                                    "file=",
                                    "with-icons",
                                    "stdout",
                                    "theme=",
                                    "submenu",
                                    "with-backgrounds",
                                    "backgrounds-only",
                                    "bg-path="])

    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            usage()
            sys.exit()
        elif opt in ("-l", "--lang"):
            lang = arg
        elif opt in ("-f", "--file"):
            file = os.path.expanduser(arg)
        elif opt == '--with-icons':
            use_icons = True
        elif opt in ("-t", "--theme"):
            theme = arg
        elif opt == '--stdout':
            use_stdout = True
        elif opt == '--stdout':
            file = sys.stdout
        elif opt == '--bg-path':
            bg_Xpath = True
            xPath = os.path.expanduser(arg)
        elif opt == '--with-backgrounds':
            use_bg = True
        elif opt == '--backgrounds-only':
            if bg_Xpath:
                get_bgimgs_and_parse(xPath)
            else:
                get_bgimgs_and_parse(None)
                raise SystemExit
        elif opt == '--submenu':
            do_submenu = True

    if not use_stdout:
        fsock = open(file, 'w')
        saveout = sys.stdout
        sys.stdout = fsock

    for filename in ["applications.menu", "gnome-applications.menu", "gnomecc.menu", "settings.menu"]:
	try:
	    menu = xdg.Menu.parse(filename)
	    break
	except ParsingError:
	    continue

    if not do_submenu:
        print header()
    for filename in ["applications.menu", "gnome-applications.menu", "settings.menu"]:
	try:
	    for entry in xdg.Menu.parse(filename).getEntries():
		if isinstance(entry, xdg.Menu.Menu):
		    parseMenu(entry, wm, use_icons, theme)
	except ParsingError:
	    continue
    if not do_submenu and use_bg and bg_Xpath:
        get_bgimgs_and_parse(xPath)
        print "[include] (~/.fluxbox/bgmenu)"
    if not do_submenu and use_bg and not bg_Xpath:
        print "[include] (~/.fluxbox/bgmenu)"
        get_bgimgs_and_parse(None)
    if not do_submenu:
        print footer()
    if not use_stdout:
        sys.stdout = saveout


if __name__ == "__main__":
    main(sys.argv[1:])