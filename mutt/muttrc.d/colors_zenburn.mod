# vim:syntax=muttrc:
#
# Screenshot http://trovao.droplinegnome.org/stuff/mutt-zenburnt.png
#
# This is a zenburn-based mutt color scheme that is not (even by far)
# complete. There's no copyright involved. Do whatever you want with it.
# Just be aware that I won't be held responsible if the current color-scheme
# explodes your mail client. ;)
#
# Do notice that this color scheme requires a terminal emulator that supports
# 256 color. Any modern X terminal emulator should have support for that and
# you can enable it by calling mutt as "TERM=xterm-256color mutt" or, if you
# use screen, by adding "term screen-256color" to your .screenrc.
#
# This file is in the public domain.
#
# With some minor changes by Daniel Schömer <daniel.schoemer@gmx.net>

# general-doesn't-fit stuff
color normal     color188 default
color error      color115 color236
color markers    color142 color238
color tilde      color108 default
color status     color144 color234

# index stuff
color indicator  color108 color236
color tree       color109 default
color index      color188 default ~A # all
color index      color227 default ~N # new
color index      color188 default ~O # old
color index      color154 default ~F # flaged
color index      color58  default ~D # deleted
color index      color173 default ~T # tagged

# header stuff
color hdrdefault color223 default
color header     color221 default "^From: "
color header     color221 default "^To: "
color header     color221 default "^Subject: "

# gpg stuff
color body       color188 default  "^gpg: Good signature.*"
color body       color115 color236 "^gpg: BAD signature.*"
color body       color174 default  "^gpg: Can't check signature.*"
color body       color174 default  "^-----BEGIN PGP SIGNED MESSAGE-----"
color body       color174 default  "^-----BEGIN PGP SIGNATURE-----"
color body       color174 default  "^-----END PGP SIGNED MESSAGE-----"
color body       color174 default  "^-----END PGP SIGNATURE-----"
color body       color174 default  "^Version: GnuPG.*"
color body       color174 default  "^Comment: .*"

# url, email and web stuff
color body       color174 default  "(finger|ftp|http|https|news|telnet)://[^ >]*"
color body       color174 default  "<URL:[^ ]*>"
color body       color174 default  "www\\.[-.a-z0-9]+\\.[a-z][a-z][a-z]?([-_./~a-z0-9]+)?"
color body       color174 default  "mailto: *[^ ]+\(\\i?subject=[^ ]+\)?"
color body       color174 default  "[-a-z_0-9.%$]+@[-a-z_0-9.]+\\.[-a-z][-a-z]+"

# misc body stuff
color attachment color174 default
color signature  color223 default

# quote levels
color quoted     color108 default
color quoted1    color116 default
color quoted2    color247 default
color quoted3    color108 default
color quoted4    color116 default
color quoted5    color247 default
color quoted6    color108 default
color quoted7    color116 default
color quoted8    color247 default
