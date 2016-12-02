# -*- coding: utf-8 -*-
import sqlite3
conn = sqlite3.connect('2014-12-snapshot.sqlite3db')
c = conn.cursor()

t = ('7',)
c.execute('SELECT * FROM reasons WHERE id=?', t)
print c.fetchone()[1]

# for row in c.execute('SELECT * FROM reasons'):
    # print str(row[0]) + ": " + row[1]

def write_html(year):
    '''
    writes an html table with the police calls for that year
    '''
    filename = 'calls_' + str(year) + '.html'
    with open(filename, 'w') as html_out:
        doc_header = '<!DOCTYPE html>\n<html>'
        html_out.write(doc_header)
        doc_style = '\n<style>\n  table  {margin:auto; border: 1px solid black;}\n  th, td   {border: 1px solid black; text-align: center;}\n</style>'
        html_out.write(doc_style)
        html_out.write('\n<body>\n<table>\n')
        html_out.write('\t<tr>\n')
        html_out.write('\t\t<th>ID</th>\n')
        html_out.write('\t\t<th>Description</th>\n')
        for row in c.execute('SELECT * FROM calls'):
            
            id = str(row[0])
            time = row[1]
            this_year = int(time[0:4])
            if this_year != year: continue
            lat = row[3]
            long = row[4]
            address = row[5]
            html_out.write('\t<tr>\n')
            html_out.write('\t\t<td>' + id + '</td>\n')
            html_out.write('\t\t<td>' + time + '</td>\n')
            html_out.write('\t\t<td>' + str(lat) + '</td>\n')
            html_out.write('\t\t<td>' + str(long) + '</td>\n')
            try:
                html_out.write('\t\t<td>' + address + '</td>\n')
            except UnicodeEncodeError:
                html_out.write('\t\t<td>' + 'error' + '</td>\n')
                print 'error found on record:', id, 'of year', year
            html_out.write('\t</tr>\n')
        html_out.write('</table>\n</body>\n</html>')

for year in range(2009, 2015):
    write_html(year)