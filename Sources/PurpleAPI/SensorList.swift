//
//  SensorList.swift
//  PurpleAPI
//
//  Created by Chris Ballinger on 8/22/20.
//

import Foundation
import AnyCodable
import CoreLocation

public struct SensorList: Codable {
    enum Field: String, Codable {
        case id = "ID"
        case pm
        case age
        case pm_0
        case pm_1
        case pm_2
        case pm_3
        case pm_4
        case pm_5
        case pm_6
        case conf
        case pm1
        case pm_10
        case p1
        case p2
        case p3
        case p4
        case p5
        case p6
        case humidity = "Humidity"
        case temperature = "Temperature"
        case pressure = "Pressure"
        case elevation = "Elevation"
        case type = "Type"
        case label = "Label"
        case latitude = "Lat"
        case longitude = "Lon"
        case icon = "Icon"
        case isOwner
        case flags = "Flags"
        case voc = "Voc"
        case ozone1 = "Ozone1"
        case adc = "Adc"
        case ch = "CH"
    }
    var version: String
    var fields: [Field]
    var data: [[AnyCodable]]
    var count: Int
    
    struct RawSensor {
        var fields: [Field: AnyCodable]
    }
    struct Sensor {
        var id: Int
        var label: String
        var coordinate: CLLocationCoordinate2D
    }
    var sensors: [Sensor] {
        let rawSensors: [RawSensor] = data.map {
            var sensor = RawSensor(fields: [:])
            for (index, field) in fields.enumerated() {
                sensor.fields[field] = $0[index]
            }
            return sensor
        }
        let sensors = rawSensors.compactMap { Sensor(fields: $0.fields) }
        if sensors.count != count {
            print("Sensors count doesn't match, data may be missing")
        }
        return sensors
    }
}

extension SensorList.Sensor {
    init?(fields: [SensorList.Field: AnyCodable]) {
        guard let id = fields[.id]?.value as? Int,
            let latitude = fields[.latitude]?.value as? CLLocationDegrees,
            let longitude = fields[.longitude]?.value as? CLLocationDegrees,
            let label = fields[.label]?.value as? String else {
                return nil
        }
        self.id = id
        self.label = label
        self.coordinate = .init(latitude: latitude, longitude: longitude)
    }
}
