#!/usr/bin/env python
import indicate
import gobject
import gtk
from time import time
import os

curdir = os.getcwd() 
desktop_file = os.path.join(curdir, "example-indicator.desktop")

def timeout_cb(indicator):
    print "Modifying properties"
    indicator.set_property_time("time", time())
    return True

def display(indicator):
    print "Ah, my indicator has been displayed"
    indicator.hide()

def server_display(server):
    print "Ah, my server has been displayed"

# Setup the server
server = indicate.indicate_server_ref_default()
server.set_type("message.im")
server.set_desktop_file(desktop_file)
server.connect("server-display", server_display)
server.show()

# Setup the message
indicator = indicate.IndicatorMessage()
indicator.set_property("subtype", "im")
indicator.set_property("sender", "Test message")
indicator.set_property("body", "Test message body")
indicator.set_property_time("time", time())
indicator.show()
indicator.connect("user-display", display)

# Loop
gobject.timeout_add_seconds(5, timeout_cb, indicator)
gtk.main()
