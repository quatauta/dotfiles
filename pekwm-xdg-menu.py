#!/usr/bin/env python
# vim: noexpandtab:ts=4:sts=4

"""Menu Generator for PekWM 
Generates a dynamic menu for PekWM using the freedesktop.org standards

Usage:

  Options:
  -l ..., --lang=...      create the menu using a language. Default = $LANG
  -h, --help              show this help

"""

__author__ = "Michael Rice , Rudolf Kastl , Antonio Gomes"
__version__ = "$Revision: 1.0 $"
__date__ = "$Date: 2006/10/12 18:20:10 $"
__license__ = "GPL"

import xdg.Menu,xdg.DesktopEntry
import getopt,os,sys

def usage():
	print __doc__

def checkWm(entry):
	if entry.DesktopEntry.getOnlyShowIn() != []:
		entry.Show = False
	if entry.DesktopEntry.getNotShowIn() != []:
		if isinstance(entry, xdg.Menu.MenuEntry):
			if wm in entry.DesktopEntry.getNotShowIn():
				entry.Show = False
			else:
				entry.Show = True 
	
def parseMenu(menu,depth=1):
    print "%s Submenu =  \"%s\" {" % ( (depth*"\t"), menu.getName().encode('utf8'), )
    depth += 1
    for entry in menu.getEntries():
		if isinstance(entry, xdg.Menu.Menu):
			parseMenu(entry,depth)
		elif isinstance(entry, xdg.Menu.MenuEntry):
		    checkWm(entry)
		    if entry.Show == False: continue
		    print "%sEntry = \"%s\" { Actions = \"Exec %s &\" }  " % ( (depth*"\t"), \
		      entry.DesktopEntry.getName().encode("utf8"), \
		  	  entry.DesktopEntry.getExec().split()[0]) 
		elif isinstance(entry,xdg.Menu.Separator):
			print "%sSeparator {}" % (depth*"\t")
		elif isinstance(entry.xdg.Menu.Header):
			print "%s%s" % ( (depth*"\t"), entry.Name )
	depth -= 1
	print "%s}" % (depth*"\t")
def main(argv):
	lang = os.getenv("LANG","C")
	try:
	    opts, args = getopt.getopt(argv, "hf:dl:d", ["help","lang="])
	except getopt.GetoptError:
	    usage()
		raise SystemExit
	for opt, arg in opts:
	    if opt in ("-h", "--help"):
		    usage()
			raise SystemExit
		elif opt in ("-l", "--lang"):
		    lang = arg
	
	menu=xdg.Menu.parse()
	print "Dynamic {"
	parseMenu(menu)
	print "}"

if __name__ == "__main__":
	main(sys.argv[1:])
