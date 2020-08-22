//
//  PurpleSensor.swift
//  PurpleWatch
//
//  Created by Chris Ballinger on 11/18/18.
//  Copyright © 2018 Chris Ballinger. All rights reserved.
//

import Foundation
import CoreLocation

public struct PurpleSensorResponse: Codable {
    public var baseVersion: String
    public var mapVersion: String
    public var results: [PurpleSensor]
}

public struct Identifier<Parent, T: Codable>: Codable {
    public init(_ rawValue: T) {
        self.rawValue = rawValue
    }
    public var rawValue: T
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.rawValue = try container.decode(T.self)
    }
}

extension PurpleSensor.SensorId: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    public typealias IntegerLiteralType = Int
}

public struct PurpleSensor: Codable {
    private static let statsDecoder = JSONDecoder()
    
    public typealias SensorId = Identifier<PurpleSensor, Int>
    
    public var sensorId: SensorId
    public var parentId: SensorId?
    
    public enum LocationType: String, Codable {
        case inside
        case outside
    }

    public var label: String
    public var locationType: LocationType?
    private var pm2_5: String?
    private var statsJSON: String?
    public var stats: Stats? {
        guard let data = statsJSON?.data(using: .utf8),
            let stats = try? PurpleSensor.statsDecoder.decode(Stats.self, from: data) else {
            return nil
        }
        return stats
    }
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    private var latitude: CLLocationDegrees
    private var longitude: CLLocationDegrees
    
    public var lastSeen: Date {
        return Date(timeIntervalSince1970: lastSeenEpoch)
    }
    /// last seen in unix time
    private var lastSeenEpoch: TimeInterval

    
    enum CodingKeys: String, CodingKey {
        case sensorId = "ID"
        case latitude = "Lat"
        case longitude = "Lon"
        case parentId = "ParentID"
        case label = "Label"
        case lastSeenEpoch = "LastSeen"
        case pm2_5 = "PM2_5Value"
        case statsJSON = "Stats"
    }
    
    public struct Stats: Codable {
        // 1542491205491
        private var lastModified: Double
        private var lastModifiedEpoch: TimeInterval {
            return lastModified / 1000
        }
        public var lastModifiedDate: Date {
            return Date(timeIntervalSince1970: lastModifiedEpoch)
        }
        
        /// now
        public var pm: PM25
        /// now
        public var v: PM25
        /// 10 min avg
        public var v1: PM25
        /// 30 min avg
        public var v2: PM25
        /// 1 hr avg
        public var v3: PM25
        /// 6 hr avg
        public var v4: PM25
        /// 24 hr avg
        public var v5: PM25
        /// 1 week avg
        public var v6: PM25
    }
}

