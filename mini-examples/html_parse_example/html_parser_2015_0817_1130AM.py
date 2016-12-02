# -*- coding: utf-8 -*-

from HTMLParser import HTMLParser

class MyHTMLParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.this_tag = None
        self.this_data = None
    def handle_starttag(self, tag, attrs):
        self.this_tag = tag
        print "setting self.this_tag to:", tag
    def handle_data(self, data):
        self.this_data = data
        print "setting self.this_data to:", data
    def get_tag(self):
        return self.this_tag     
    def get_data(self):
        return self.this_data

parser = MyHTMLParser()

with open('reasons_small.html', 'r') as html_file:
    for row in html_file:
        parser.feed(row)
        tag = parser.get_tag()
        data = parser.get_data()
        print "row:", row
        print "tag:", tag
        print "data:", data
        # if tag == 'td' and data:
            # print data
            # parser.this_tag = None
        
