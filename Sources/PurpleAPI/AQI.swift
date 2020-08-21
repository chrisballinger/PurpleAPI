//
//  AQI.swift
//  PurpleWatch
//
//  Created by Chris Ballinger on 11/18/18.
//  Copyright © 2018 Chris Ballinger. All rights reserved.
//

import Foundation

public struct AQI: RawRepresentable {
    
    public enum Level: CaseIterable {
        // 0-50
        case good
        // 51-100
        case moderate
        // 101-150
        case unhealthyForSensitiveGroups
        // 151-200
        case unhealthy
        // 201-300
        case veryUnhealthy
        // 301-500
        case hazardous
    }
    public var level: Level {
        let aqi = rawValue
        if aqi <= 50 {
            return .good
        } else if aqi <= 100 && aqi > 50 {
            return .moderate
        } else if aqi <= 150 && aqi > 100 {
            return .unhealthyForSensitiveGroups
        } else if aqi <= 200 && aqi > 150 {
            return .unhealthy
        } else if aqi <= 300 && aqi > 200 {
            return .veryUnhealthy
        } else {
            // 301-500
            return .hazardous
        }
    }
    
    public init(pm2_5: Float) {
        self.rawValue = AQIPM25(Concentration: pm2_5)
    }
    
    public init(pm2_5: PM25) {
        self.rawValue = AQIPM25(Concentration: Float(pm2_5.rawValue))
    }
    
    public init?(rawValue: Float) {
        self.rawValue = rawValue
    }
    public var rawValue: Float
    public typealias RawValue = Float
}

extension AQI: CustomStringConvertible {
    public var description: String {
        return "\(Int(rawValue.rounded()))"
    }
}

extension AQI.Level: CustomStringConvertible {
    public var description: String {
        switch self {
        case .good:
            return "Good"
        case .moderate:
            return "Moderate"
        case .unhealthyForSensitiveGroups:
            return "Unhealthy (Sensitive)"
        case .unhealthy:
            return "Unhealthy"
        case .veryUnhealthy:
            return "Very Unhealthy"
        case .hazardous:
            return "Hazardous"
        }
    }
}

// https://www.airnow.gov/js/conc-aqi.js
private func Linear(_ AQIhigh: Float, _ AQIlow: Float, _ Conchigh: Float, _ Conclow: Float, _ Concentration: Float) -> Float {
    return ((Concentration-Conclow)/(Conchigh-Conclow))*(AQIhigh-AQIlow)+AQIlow
}

private func AQIPM25(Concentration: Float) -> Float
{
    let c = (floor(10*Concentration))/10
    var AQI: Float
    if (c>=0 && c<12.1)
    {
        AQI=Linear(50,0,12,0,c)
    }
    else if (c>=12.1 && c<35.5)
    {
        AQI=Linear(100,51,35.4,12.1,c)
    }
    else if (c>=35.5 && c<55.5)
    {
        AQI=Linear(150,101,55.4,35.5,c)
    }
    else if (c>=55.5 && c<150.5)
    {
        AQI=Linear(200,151,150.4,55.5,c)
    }
    else if (c>=150.5 && c<250.5)
    {
        AQI=Linear(300,201,250.4,150.5,c)
    }
    else if (c>=250.5 && c<350.5)
    {
        AQI=Linear(400,301,350.4,250.5,c)
    }
    else if (c>=350.5 && c<500.5)
    {
        AQI=Linear(500,401,500.4,350.5,c)
    }
    else
    {
        // out of AQI range
        AQI = 500
    }
    return AQI
}
