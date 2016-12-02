# -*- coding: utf-8 -*-
import xml.etree.ElementTree as ET
#from lxml import html
import requests
import urllib2

tree = ET.parse('country_data.xml')
root = tree.getroot()

print root.tag

print "root.tag has type", type(root.tag)
print "root.attrib has type", type(root.attrib)

print "\nPrinting each country..."
for child in root:
    print(child.tag, child.attrib)

print "\nPrinting each neighbor..."    
for neighbor in root.iter('neighbor'):
    print(neighbor.attrib)

# Element.findall() finds only elements with a tag which are direct children of the current element
# Element.find() finds the first child with a particular tag
# Element.text accesses the element’s text content
# Element.get() accesses the element’s attributes

    
for country in root.findall('country'):
    rank = country.find('rank').text
    name = country.get('name')
    print(name, rank)
    



    
