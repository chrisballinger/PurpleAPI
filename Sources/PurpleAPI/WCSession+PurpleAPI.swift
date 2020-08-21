//
//  WCSession+PurpleAPI.swift
//  PurpleWatch
//
//  Created by Chris Ballinger on 11/18/18.
//  Copyright © 2018 Chris Ballinger. All rights reserved.
//

import WatchConnectivity

extension WCSession {
    struct PropertyList: Codable {
        
    }
    
    static let encoder = JSONEncoder()
    static let decoder = JSONEncoder()
    enum ContextKeys: String {
        case reading
    }
//
//    func updateApplicationContext(response: PurpleSensorResponse) {
//        do {
//            let data = try WCSession.encoder.encode(response)
//            self.updateApplicationContext([])
//        } catch {
//            NSLog("Error updating context \(error)")
//        }
//
//
//    }
//
//    func sensorResponseFromApplicationContext() -> PurpleSensorResponse? {
//        return nil
//    }
    
}
