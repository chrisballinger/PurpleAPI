//
//  AQIColor.swift
//  PurpleWatch
//
//  Created by Chris Ballinger on 11/18/18.
//  Copyright © 2018 Chris Ballinger. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#endif

#if canImport(UIKit) || canImport(WatchKit)

extension AQI.Level {
    public var color: UIColor {
        switch self {
        case .good:
            return .aqiGreen
        case .moderate:
            return .aqiYellow
        case .unhealthyForSensitiveGroups:
            return .aqiOrange
        case .unhealthy:
            return .aqiRed
        case .veryUnhealthy:
            return .aqiPurple
        case .hazardous:
            return .aqiMaroon
        }
    }
    
    public var textColor: UIColor {
        switch self {
        case .good:
            return .black
        case .moderate:
            return .black
        case .unhealthyForSensitiveGroups:
            return .white
        case .unhealthy:
            return .white
        case .veryUnhealthy:
            return .white
        case .hazardous:
            return .white
        }
    }
}

extension UIColor {
    // https://stackoverflow.com/a/27270584/805882
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    convenience init(red8: UInt8, green8: UInt8, blue8: UInt8) {
        let components = (
            R: CGFloat(red8) / 255,
            G: CGFloat(green8) / 255,
            B: CGFloat(blue8) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    static var aqiGreen: UIColor {
        return UIColor(hex: 0x00E400)
    }
    
    static var aqiYellow: UIColor {
        return UIColor(hex: 0xFFFF00)
    }
    
    static var aqiOrange: UIColor {
        return UIColor(hex: 0xFF7E00)
    }
    
    static var aqiRed: UIColor {
        return UIColor(hex: 0xFF0000)
    }
    
    static var aqiMaroon: UIColor {
        return UIColor(hex: 0x7E0023)
    }
    
    static var aqiPurple: UIColor {
        return UIColor(red8: 143, green8: 63, blue8: 151)
    }
}

#endif
