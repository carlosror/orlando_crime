# -*- coding: utf-8 -*-
import xml.etree.ElementTree as ET
import urllib2

file = urllib2.urlopen('http://www1.cityoforlando.net/opd/activecalls/')
police_dispatch_data = file.read()

root = ET.fromstring(police_dispatch_data)

# Element.findall() finds only elements with a tag which are direct children of the current element
# Element.find() finds the first child with a particular tag
# Element.text accesses the element’s text content
# Element.get() accesses the element’s attributes
    
for call in root.findall('CALL'):
    incident = call.get('incident')
    date = call.find('DATE').text
    description = call.find('DESC').text
    location = call.find('LOCATION').text
    district = call.find('DISTRICT').text
    print incident, date, description, location, district