#!/usr/bin/env python
# Code forked from jrsmith3's old code to resolve bibtex metadata from DOI
# updated by M.R.S. (siegfried@mines.edu) and wrapped by doi2bib.sh for an
# easy shell script that tweaks the output to suite my needs.
# https://gist.github.com/jrsmith3/5513926

import requests
import sys


def doi2bib(doi):
  """
  Return a bibTeX string of metadata for a given DOI.
  """
 
  url = "http://dx.doi.org/" + doi
 
  headers = {"accept": "application/x-bibtex"}
  r = requests.get(url, headers = headers, timeout=3)

  s = ''.join(r.text).encode('utf-8').strip()
  print(s.decode('utf-8'))
  return s.decode('utf-8')

if __name__ == "__main__":
  doi2bib(*sys.argv[1:])
