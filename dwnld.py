"""
    500px wallpaper.
    Author: Aaditya M Nair (Prometheus)	
    Created On : Fri 09 Jan 2015 00:09:28 IST

    Download a random image from 500px.
"""

import urllib
#TODO Fri 09 Jan 2015 01:35:54 IST Similar API can be generated for desktopnexus(nature.desktopnexus.com)

def download(pageResource):
    pattern="{\"size\":2048,\"url\":"
    start = pageResource.find(pattern)+20
    end = pageResource.find("\"", start+2)
    imgLink = pageResource[start:end]
    imgLink=imgLink.replace("\\", "")          
    urllib.urlretrieve(imgLink, "temp.jpg")

def vlad(pageResource):
    """
    to download from vladstudio.com
    will be written someday.
    """

