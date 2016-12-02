# -*- coding: utf-8 -*-
import sqlite3
conn = sqlite3.connect('2014-12-snapshot.sqlite3db')
c = conn.cursor()

t = ('7',)
c.execute('SELECT * FROM reasons WHERE id=?', t)
print c.fetchone()[1]

# for row in c.execute('SELECT * FROM reasons'):
    # print str(row[0]) + ": " + row[1]

with open('reasons.html', 'w') as html_out:
    doc_header = '<!DOCTYPE html>\n<html>'
    html_out.write(doc_header)
    doc_style = '\n<style>\n  table  {margin:auto; border: 1px solid black;}\n  th, td   {border: 1px solid black; text-align: center;}\n</style>'
    html_out.write(doc_style)
    html_out.write('\n<body>\n<table>\n')
    html_out.write('\t<tr>\n')
    html_out.write('\t\t<th>ID</th>\n')
    html_out.write('\t\t<th>Description</th>\n')
    for row in c.execute('SELECT * FROM reasons'):
        html_out.write('\t<tr>\n')
        id = str(row[0])
        desc = row[1]
        html_out.write('\t\t<td>' + id + '</td>\n')
        html_out.write('\t\t<td>' + desc + '</td>\n')
        html_out.write('\t</tr>\n')
    html_out.write('</table>\n</body>\n</html>')