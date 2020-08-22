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
        func value<T>(for field: Field) -> T? {
            fields[field]?.value as? T
        }
        subscript<T>(field: Field) -> T? {
            get {
                value(for: field)
            }
        }
    }
    public struct Sensor {
        public var id: PurpleSensor.SensorId
        public var label: String
        public var coordinate: CLLocationCoordinate2D
        public var pm1: PM25?
        public enum LocationType: Int {
            case outdoors = 0
            case indoors = 1
        }
        public var locationType: LocationType
    }
    
    public var sensors: [Sensor] {
        let rawSensors: [RawSensor] = data.map {
            var sensor = RawSensor(fields: [:])
            for (index, field) in fields.enumerated() {
                sensor.fields[field] = $0[index]
            }
            return sensor
        }
        let sensors = rawSensors.compactMap { Sensor($0) }
        if sensors.count != count {
            print("Sensors count doesn't match, data may be missing")
        }
        return sensors
    }
}

extension SensorList.Sensor {
    init?(_ sensor: SensorList.RawSensor) {
        guard let rawId: Int = sensor[.id],
            let latitude: CLLocationDegrees = sensor[.latitude],
            let longitude: CLLocationDegrees = sensor[.longitude],
            let label: String = sensor[.label],
            let rawType: Int = sensor[.type],
            let type = LocationType(rawValue: rawType) else {
                return nil
        }
        let rawPM1: Double? = sensor.value(for: .pm_1)
        self.id = PurpleSensor.SensorId(rawId)
        self.label = label
        self.locationType = type
        self.pm1 = rawPM1.map { PM25($0) }
        self.coordinate = .init(latitude: latitude, longitude: longitude)
    }
}
