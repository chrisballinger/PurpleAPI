//
//  PM25.swift
//  PurpleWatch
//
//  Created by Chris Ballinger on 11/18/18.
//  Copyright © 2018 Chris Ballinger. All rights reserved.
//

import Foundation

public struct PM25: Hashable, Codable, CustomStringConvertible, Comparable {
    public static func < (lhs: PM25, rhs: PM25) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    public init(_ microgramsPerMetersCubed: Double) {
        self.rawValue = microgramsPerMetersCubed
    }
    
    public var rawValue: Double
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(Double.self)
        self.init(raw)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
    public var description: String {
        return measurementValue.description
    }
    
    public var aqi: AQI {
        return AQI(pm2_5: self)
    }
    
    public var measurementValue: Measurement<UnitConcentrationMass> {
        Measurement(value: rawValue, unit: UnitConcentrationMass.microgramsPerMetersCubed)
    }
}

extension PM25: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self.init(Double(value))
    }
    
    public typealias FloatLiteralType = Double
}


extension PM25: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(Double(value))
    }
    
    public typealias IntegerLiteralType = Int
}

extension UnitConcentrationMass {
    static let microgramsPerMetersCubed: UnitConcentrationMass = {
        let coefficient = pow(10.0, -9.0)
        let converter = UnitConverterLinear(coefficient: coefficient)
        return UnitConcentrationMass(symbol: "µg/m³", converter: converter)
    }()
}
