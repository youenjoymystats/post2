import urllib, json, sys, csv
from collections import Counter
from pygeocoder import Geocoder
from time import sleep
def getCities():
    url='https://api.phish.net/'
    endpoint='api.js'

##    threepointoh = ['2009','2010','2011','2012','2013','2014','2015']
    allShows = [str(x) for x in range(1989,1995)]
    cityDict = {}
    showDict = {}
    locList = []

    settings = open("settings.txt")
    apikey = settings.read()
    settings.close()
    format = 'json'
    apiver = '2.0'
    method = 'pnet.shows.query'
    country = "USA"

    params = urllib.urlencode({
      'api':apiver,
      'method':method,
      'format':format,
      'apikey':apikey,
      'country':country
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
        i = 0
        for show in decoded:

            city = show[u'city'] + ", " + show[u'state']
            city = city.encode('ascii','ignore')
            date = show[u'showdate']
            try:
                if city not in cityDict:
                    i+=1
                    if i%5 == 0:
                        sleep(1)
                    loc = Geocoder.geocode(city.encode('ascii','ignore'))[0].coordinates
                    latlon = str(loc[0]) + ":" + str(loc[1])
                    cityDict[city] = latlon
                    
                if city not in showDict:
                    showDict[city] = [date]
                else:
                    showDict[city].append(date)

                locList.append(city)
            except:
                print city

      
      
      #Print the Decoded JSON 
      #print 'DECODED: ', decoded

      #Print an individual JSON Record
      #print 'GET INDIVIDUAL RECORD: ', decoded[0]['showdate']

    else:
      #Do this if the not an HTTP response of 200
        print 'Error - HTTP Response Code: ',  rsp

    #close the connection
    f.close()
    writer = csv.writer(open('cities.csv', 'wb'))
    writer.writerow(["latlon","city","count","dates"])
    for key, value in dict(Counter(locList)).items():
        writer.writerow([cityDict[key],key,value, '<br/>'.join(showDict[key])])







