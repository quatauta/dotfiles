#!/bin/sh

# https://developers.yubico.com/ykneo-openpgp/ResetApplet.html

# I have tested this script with a single YubiKey Neo (bought April 2014 in Germany).
#
# Use at your own risk and with caution. This should erase all settings of the OpenPGP
# applet on the YubiKey. It may do some harm to your YubiKey!

echo "ATTENTION: THIS WILL RESET YOUR Yubikey OpenPGP SETTINGS!"
echo
echo "Continue?"

read CONTINUE

if [ "${CONTINUE}" = "YES" ] ; then
    echo "Waiting 10 seconds to regret your answer ..."
    sleep 10 &&
    gpg-connect-agent <<-EOF
	/hex
	scd serialno
	scd apdu 00 20 00 81 08 40 40 40 40 40 40 40 40
	scd apdu 00 20 00 81 08 40 40 40 40 40 40 40 40
	scd apdu 00 20 00 81 08 40 40 40 40 40 40 40 40
	scd apdu 00 20 00 81 08 40 40 40 40 40 40 40 40
	scd apdu 00 20 00 83 08 40 40 40 40 40 40 40 40
	scd apdu 00 20 00 83 08 40 40 40 40 40 40 40 40
	scd apdu 00 20 00 83 08 40 40 40 40 40 40 40 40
	scd apdu 00 20 00 83 08 40 40 40 40 40 40 40 40
	scd apdu 00 e6 00 00
	scd apdu 00 44 00 00
	/echo Card has been successfully reset.
	/bye
	EOF
fi
