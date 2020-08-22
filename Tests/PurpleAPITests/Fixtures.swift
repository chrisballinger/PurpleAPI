//
//  PurpleWatchTests.swift
//  PurpleWatchTests
//
//  Created by Chris Ballinger on 11/17/18.
//  Copyright © 2018 Chris Ballinger. All rights reserved.
//

enum Fixtures {
    static var sensor: String {
#"""
{
    "baseVersion": "6",
    "mapVersion": "0.70",
    "mapVersionString": "",
    "results": [
        {
            "AGE": 0,
            "A_H": null,
            "DEVICE_BRIGHTNESS": "15",
            "DEVICE_FIRMWAREVERSION": null,
            "DEVICE_HARDWAREDISCOVERED": "2.0+PMSX003A+PMSX003B+BME280",
            "DEVICE_LOCATIONTYPE": "outside",
            "Flag": null,
            "Hidden": "false",
            "ID": 4506,
            "Label": "North Berkeley",
            "LastSeen": 1542491205,
            "LastUpdateCheck": 1542489755,
            "Lat": 37.875165,
            "Lon": -122.27071,
            "PM2_5Value": "105.62",
            "ParentID": null,
            "RSSI": "-55",
            "State": null,
            "Stats": "{\"v\":105.62,\"v1\":107.5,\"v2\":118.59,\"v3\":131.7,\"v4\":168.6,\"v5\":182.83,\"v6\":94.86,\"pm\":105.62,\"lastModified\":1542491205491,\"timeSinceModified\":80003}",
            "THINGSPEAK_PRIMARY_ID": "367267",
            "THINGSPEAK_PRIMARY_ID_READ_KEY": "2Y6HI5C19RMFU6UC",
            "THINGSPEAK_SECONDARY_ID": "367268",
            "THINGSPEAK_SECONDARY_ID_READ_KEY": "N4OIJ1CXT3QCT7NK",
            "Type": "PMS5003+PMS5003+BME280",
            "Uptime": "69860",
            "Version": "2.49j",
            "humidity": "42",
            "isOwner": 0,
            "pressure": "1010.63",
            "temp_f": "69"
        },
        {
            "AGE": 1,
            "A_H": null,
            "DEVICE_BRIGHTNESS": null,
            "DEVICE_FIRMWAREVERSION": null,
            "DEVICE_HARDWAREDISCOVERED": "2.0+PMSX003A+PMSX003B+BME280",
            "DEVICE_LOCATIONTYPE": null,
            "Flag": null,
            "Hidden": "false",
            "ID": 4507,
            "Label": "North Berkeley B",
            "LastSeen": 1542491155,
            "LastUpdateCheck": null,
            "Lat": 37.875165,
            "Lon": -122.27071,
            "PM2_5Value": "109.80",
            "ParentID": 4506,
            "RSSI": "-55",
            "State": null,
            "Stats": "{\"v\":109.8,\"v1\":111.99,\"v2\":123.49,\"v3\":136.65,\"v4\":172.88,\"v5\":186.83,\"v6\":97.09,\"pm\":109.8,\"lastModified\":1542491155550,\"timeSinceModified\":80041}",
            "THINGSPEAK_PRIMARY_ID": "367269",
            "THINGSPEAK_PRIMARY_ID_READ_KEY": "NQVNEBK9SYR038PK",
            "THINGSPEAK_SECONDARY_ID": "367270",
            "THINGSPEAK_SECONDARY_ID_READ_KEY": "KM0FL6PJQOL31GRF",
            "Type": null,
            "Uptime": "69810",
            "Version": "2.49j",
            "humidity": "42",
            "isOwner": 0,
            "pressure": "1010.62",
            "temp_f": "69"
        }
    ]
}
"""#
    }
    
    static var stats: String {
#"""
{
    "lastModified": 1542491205491,
    "pm": 105.62,
    "timeSinceModified": 80003,
    "v": 105.62,
    "v1": 107.5,
    "v2": 118.59,
    "v3": 131.7,
    "v4": 168.6,
    "v5": 182.83,
    "v6": 94.86
}
"""#
    }
    
    static var sensorList: String {
#"""
{"version":"7.0.15",
"fields":
["ID","pm","age","pm_0","pm_1","pm_2","pm_3","pm_4","pm_5","pm_6","conf","pm1","pm_10","p1","p2","p3","p4","p5","p6","Humidity","Temperature","Pressure","Elevation","Type","Label","Lat","Lon","Icon","isOwner","Flags","Voc","Ozone1","Adc","CH"],
"data":[
[1596,2.1,0,2.1,2.1,1.6,1.5,3.0,4.4,7.1,100,1.2,2.9,420.1,118.5,20.4,2.5,0.9,0.1,62,73,1010.68,25,0,"Pacifica Sharp Park",37.628716,-122.48773,0,0,0,null,null,0.02,3]
],
"count":1}
"""#
    }
}
