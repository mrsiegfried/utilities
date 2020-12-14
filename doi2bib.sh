#!/bin/bash
## doi2bib.sh written by M.R. Siegfried (siegfried@mines.edu)
##
## a wrapper to use doi2bib.py but change the identifying key to the Siegfried style (after the Hawley style!)
## also does some other tweaks to ensure title capitalization -- note this breaks if there is a line break in the title
## still a couple of outstanding issues:
##      * for some reason, data.crossref.org goes down a lot. If that happens, just try, try again
##      * if there are special characters in the first author's last name, the citation key gets garbled; fix by hand for now
##      * if you keep doi2bib.py in a different folder, point to it with the pyhome variable

#pyhome="$CODEHOME/py/util" #variable for where you keep the doi2bib.py file
pyhome='./'

if [[ $# -gt 2 || $# -lt 1 ]]; then
    echo "ERROR: `basename $0` requires 1 or 2 inputs"
    echo "USAGE: `basename $0` doi [bibfile]"
    exit 1
fi

if [[ ! -f "${pyhome}/doi2bib.py" ]]; then
    echo "ERROR: Can't find doi2bib.py file in ${pyhome}. Reset pyhome variable."
    echo "USAGE: `basename $0` doi [bibfile]"
    exit 2
fi


bibfile=$2

python ${pyhome}/doi2bib.py $1 > tmpbibentry
sed 1d tmpbibentry > tmp_endofbib

head -1 tmpbibentry | sed -e "s/_/:/" | tr '[:upper:]' '[:lower:]' > tmp_firstline

# double the braces around the title to ensure correct capitalization
#find title line
tline=`grep -n "title" < tmp_endofbib | cut -f1 -d:`s
sed -i -e "$tline/= {/= {{/" tmp_endofbib
sed -i -e "$tline/},/}},/" tmp_endofbib

# replace %2F with /
sed -i -e "s/%2F/\//g" tmp_endofbib

# replace %28 with (
sed -i -e "s/%28/(/g" tmp_endofbib

# replace %29 with )
sed -i -e "s/%29/)/g" tmp_endofbib

# remove month line because it's wrong most of the time
sed -i '' "/month = {/d" tmp_endofbib
echo "" > newlineatend

if [[ $# -eq 1 ]]; then
    cat tmp_firstline tmp_endofbib newlineatend
else
    cat tmp_firstline tmp_endofbib newlineatend >> $bibfile
    echo "bib entry added to $bibfile"
fi

rm tmpbibentry tmp_endofbib* tmp_firstline newlineatend
