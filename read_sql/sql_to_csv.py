# -*- coding: utf-8 -*-
import sqlite3
conn = sqlite3.connect('2014-12-snapshot.sqlite3db')
c = conn.cursor()

reasons = {}
for reason_row in c.execute('SELECT * FROM reasons'):
    reason_code = reason_row[0]
    reason = reason_row[1]
    reasons[reason_code] = reason
    
print reasons


def write_csv(year):
    '''
    writes an html table with the police calls for that year
    '''
    filename = 'calls_' + str(year) + '.csv'
    with open(filename, 'w') as csv_out:
        doc_header = 'id, time, reason, latitude, longitude, address\n'
        csv_out.write(doc_header)
        for row in c.execute('SELECT * FROM calls'):
            
            id = str(row[0])
            time = row[1]
            this_year = int(time[0:4])
            if this_year != year: continue
            reason = reasons[row[2]]
            lat = row[3]
            long = row[4]
            address = row[5]
            try:
                csv_out.write(id + ',' + time + ',' + str(reason) + ',' + str(lat) + ',' + str(long) + ',"' + address + '"\n')
            except UnicodeEncodeError:
                csv_out.write('error\n')
                print 'error found on record:', id, 'of year', year

for year in range(2014, 2015):
    write_csv(year)