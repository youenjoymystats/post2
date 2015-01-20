import urllib, json, sys, csv
from collections import Counter
from pygeocoder import Geocoder
from time import sleep

def getShows():
    url='https://api.phish.net/'
    endpoint='api.js'

##    threepointoh = ['2009','2010','2011','2012','2013','2014','2015']
    allShows = [str(x) for x in range(1983,2016)]

    rows = []

    for year in allShows:
        settings = open("settings.txt")
        apikey = settings.read()
        settings.close()
        format = 'json'
        apiver = '2.0'
        method = 'pnet.shows.query'

        params = urllib.urlencode({
          'api':apiver,
          'method':method,
          'format':format,
          'apikey':apikey,
          'year':year
          })
        
        #Attempt to open a connection and get the JSON formatted data
        try:
            f = urllib.urlopen(url + endpoint + "?%s" % params)

        #Do this for invalid URL
        except IOError:
            print 'Error: Unable to connect. Invalid URL. '
            sys.exit(1)

        #Get the response code
        rsp = f.getcode()

        #If the HTTP response is 200 (OK) then proceed 
        if rsp == 200:

            #Read the data	
            data =  f.read()

            #Decode the data as JSON
            decoded = json.loads(data)
            for show in decoded:
                try:
                    if show[u'city'] == "Burlington":
                        rows.append(["Burlington",str(show[u'showyear'])])
                    elif show[u'city'] == "New York":
                        rows.append(["NYC",str(show[u'showyear'])])
                except:
                    pass

          
          
          #Print the Decoded JSON 
          #print 'DECODED: ', decoded

          #Print an individual JSON Record
          #print 'GET INDIVIDUAL RECORD: ', decoded[0]['showdate']

        else:
          #Do this if the not an HTTP response of 200
            print 'Error - HTTP Response Code: ',  rsp

        #close the connection
        f.close()
    writer = csv.writer(open('burlington_nyc.csv', 'wb'))
    writer.writerow(["City", "Year"])
    for row in rows:
        writer.writerow(row)







