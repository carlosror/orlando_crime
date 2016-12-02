# -*- coding: utf-8 -*-

from HTMLParser import HTMLParser

class MyHTMLParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.this_tag = None
        self.this_data = None
        self.counter = 0
    def handle_starttag(self, tag, attrs):
        self.this_tag = tag
    def handle_endtag(self, tag):
        if tag == 'tr':
            self.counter = 0
    def handle_data(self, data):
        '''Assumes <td>some data</td>'''
        if self.this_tag == 'td':
            self.this_data = data
            self.counter += 1
            self.this_tag = None
            
    def get_data(self):
        return self.this_data

parser = MyHTMLParser()

with open('reasons_small.html', 'r') as html_file:
    for row in html_file:
        parser.feed(row)
        data = parser.get_data()
        if data and parser.counter < 2:
            print data,
            parser.this_data = None
        elif data and parser.counter == 2:
            print data
            parser.this_data = None
        
