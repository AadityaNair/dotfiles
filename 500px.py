#!/bin/python
"""
    500px downloader
    Author: Aaditya M Nair (Prometheus)	
    Created On : Fri 09 Jan 2015 00:23:28 IST

    Download random images from 500px
"""

# Get screen width and height
import Tkinter
root=Tkinter.Tk()
SCREEN_HEIGHT = root.winfo_screenheight()
SCREEN_WIDTH = root.winfo_screenwidth() 

from dwnld import *
import urllib2

base_url="https://www.500px.com/photo/"

import random, time
random.seed( int( time.time() ) )

def download_image():
    while True:
        val = int(( random.random())*( 10**(random.randint(2,8))))
        url = base_url + str( val )

        try:
            page = urllib2.urlopen( url ).read()
        except urllib2.HTTPError:
            continue
        else:
            download( page )
            
            # Get the size of the downloaded image. 
            from PIL import Image
            width, height = Image.open('temp.jpg').size

            # Move on if image size is larger than screen size
            if width >= SCREEN_WIDTH and height >= SCREEN_HEIGHT :
                break

    # Rename temp to wallpaper
    import shutil
    shutil.move('temp.jpg', 'wallpaper.jpg')
    
def set_wallpaper():
    SCHEMA = 'org.gnome.desktop.background'
    KEY = 'picture-uri'

    from gi.repository import Gio
    from os import path

    filename = path.abspath( 'wallpaper.jpg' )
    gsettings = Gio.Settings.new(SCHEMA)
    gsettings.apply()

download_image()
set_wallpaper()
