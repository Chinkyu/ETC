import urllib
#from BeautifulSoup import *
from bs4 import *

url = raw_input('Enter - ')
html = urllib.urlopen(url).read()
soup = BeautifulSoup(html)
# Retrieve all of the anchor tags
tags = soup('a')
for tag in tags:
    print tag.get('href', None)