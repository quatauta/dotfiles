import datetime, re

def folderfilter_gmx_local(foldername):
    wanted     = ['', '.postponed', '.sent', '.spam', '.trash', '.Feed', '.Reply Later', '.Set Aside']
    year_count = 1

    this_year = datetime.date.today().year
    years     = reversed(range(this_year - year_count, this_year + 1))

    for year in years:
        wanted.append('.INBOX.%d' % year)

    return foldername in wanted

def nametrans_local_to_gmx(foldername):
    transformed = foldername
    transforms = {
        "":          "INBOX",
        "postponed": "Entw&APw-rfe",
        "sent":      "Gesendet",
        "spam":      "Spamverdacht",
        "trash":     "Gel&APY-scht",
    }

    transformed = re.sub(r'^\.', '', foldername, 1)
    transformed = re.sub(r'\.', '/', transformed)
    transformed = transforms.get(transformed, transformed)

    # print "nametrans_local_to_gmx(\"%s\") -> \"%s\"" % ( foldername, transformed )

    return transformed

def nametrans_gmx_to_local(foldername):
    transformed = foldername
    transforms = {
        "INBOX":        "",
        "Entw&APw-rfe": "postponed",
        "Gel&APY-scht": "trash",
        "Gesendet":     "sent",
        "Spamverdacht": "spam",
    }

    transformed = transforms.get(foldername, foldername)

    if transformed != "":
        transformed = "." + transformed

    transformed = re.sub(r'/', '.', transformed)

    # print "nametrans_gmx_to_local(\"%s\") -> \"%s\"" % ( foldername, transformed )

    return transformed

def nametrans_gmx_to_gmail(foldername):
    transformed = foldername
    transforms = {
        "INBOX":        "INBOX",
        "Entw&APw-rfe": "[Google Mail]/Entw&APw-rfe",
        "Gel&APY-scht": "[Google Mail]/Papierkorb",
        "Gesendet":     "[Google Mail]/Gesendet",
        "Spamverdacht": "[Google Mail]/Spam",
    }

    transformed = transforms.get(foldername, foldername)
    transformed = re.sub(r'^INBOX/', '', transformed)

    # print "nametrans_gmx_to_gmail(\"%s\") -> \"%s\"" % ( foldername, transformed )

    return transformed

def nametrans_gmail_to_gmx(foldername):
    transformed = foldername
    transforms = {
        "INBOX":                      "INBOX",
        "[Google Mail]/Entw&APw-rfe": "Entw&APw-rfe",
        "[Google Mail]/Papierkorb":   "Gel&APY-scht",
        "[Google Mail]/Gesendet":     "Gesendet",
        "[Google Mail]/Spam":         "Spamverdacht",
    }

    if (not re.match(r'^(INBOX|\[Google Mail\]/)', transformed)):
        transformed = 'INBOX/' + transformed

    transformed = transforms.get(transformed, transformed)

    # print "nametrans_gmail_to_gmx(\"%s\") -> \"%s\"" % ( foldername, transformed )

    return transformed
