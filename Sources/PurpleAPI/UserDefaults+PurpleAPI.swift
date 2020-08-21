//
//  UserDefaults+PurpleAPI.swift
//  PurpleWatch
//
//  Created by Chris Ballinger on 11/18/18.
//  Copyright © 2018 Chris Ballinger. All rights reserved.
//

import Foundation

extension UserDefaults {
    public static let updateNotificationName = Notification.Name(rawValue: "UserDefaultsUpdateNotification")
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    public enum Keys: String {
        case lastSensorResponse
    }
    
    public enum UpdateKeys: String {
        case updatedKeyPath
    }
    
    public static var lastSensorResponse: PurpleSensorResponse? {
        set {
            encodeObject(newValue, forKey: .lastSensorResponse)
        }
        get {
            return decodeObject(forKey: .lastSensorResponse)
        }
    }
    
    private static func encodeObject<T: Encodable>(_ object: T?, forKey key: UserDefaults.Keys) {
        defer {
            NotificationCenter.default.post(name: UserDefaults.updateNotificationName, object: UserDefaults.standard, userInfo: [UpdateKeys.updatedKeyPath: key])
        }
        guard let object = object,
            let data = try? UserDefaults.encoder.encode(object) else {
                UserDefaults.standard.set(nil, forKey: key.rawValue)
                return
        }
        UserDefaults.standard.set(data, forKey: key.rawValue)
    }
    
    private static func decodeObject<T: Decodable>(forKey key: UserDefaults.Keys) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key.rawValue),
            let object = try? UserDefaults.decoder.decode(T.self, from: data) else {
                return nil
        }
        return object
    }
}
