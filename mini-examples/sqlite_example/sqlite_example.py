# -*- coding: utf-8 -*-
import sqlite3
conn = sqlite3.connect('2014-12-snapshot.sqlite3db')
c = conn.cursor()

t = ('7',)
c.execute('SELECT * FROM reasons WHERE id=?', t)
print c.fetchone()[1]

# for row in c.execute('SELECT * FROM reasons'):
    # print str(row[0]) + ": " + row[1]

with open('reasons.xml', 'w') as xml_out:
    header = '<?xml version="1.0" encoding="UTF-8"?>\n<?xml-stylesheet type="text/xml" href="reasons_style.xsl"?>'
    xml_out.write(header)
    xml_out.write('\n<REASONS>\n')
    for row in c.execute('SELECT * FROM reasons'):
        xml_out.write('\t<REASON>\n')
        id = str(row[0])
        desc = row[1]
        xml_out.write('\t\t<ID>' + id + '</ID>\n')
        xml_out.write('\t\t<DESC>' + desc + '</DESC>\n')
        xml_out.write('\t</REASON>\n')
    xml_out.write('</REASONS>\n')