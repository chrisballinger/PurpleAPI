//
//  PurpleAPIClient.swift
//  PurpleAPI
//
//  Created by Chris Ballinger on 11/18/18.
//  Copyright © 2018 Chris Ballinger. All rights reserved.
//

import Foundation
#if os(watchOS)
import WatchKit
import ClockKit
#endif
import CoreLocation

public class PurpleAPIClient: NSObject {
    private var session: URLSession?
    private let decoder = JSONDecoder()
    private let baseURL = URL(string: "https://www.purpleair.com/")!
    public static let shared = PurpleAPIClient()
    
    public override init() {
        super.init()
        self.session = URLSession(configuration: .purple, delegate: self, delegateQueue: nil)
    }
    
    public func fetchSensor(id: PurpleSensor.SensorId) {
        guard var components = components else {
            return
        }
        components.urlPath = .fetchSensor
        components.queryItems = [
            URLQuery.fetchSensor.queryItem(value: "\(id)")
        ]
        guard let url = components.url else {
            return
        }
        let request = URLRequest(url: url)
        print("Fetching Sensor Data: \(url)")
        let task = session?.downloadTask(with: request)
        task?.resume()
    }
    
    public func fetchSensors(northWest: CLLocationCoordinate2D,
                             southEast: CLLocationCoordinate2D) {
        // https://www.purpleair.com/data.json?opt=1/i/mAQI/a10/cC0&fetch=true&nwlat=37.95280545255774&selat=37.723966026666204&nwlng=-122.43809247307286&selng=-122.23587537102202&fields=pm_1
        guard var components = components else {
            return
        }
        components.urlPath = .fetchSensorList
        components.queryItems = [
            .init(name: "opt", value: "1/i/mAQI/a10/cC0"),
            .init(name: "fetch", value: "true"),
            .init(name: "nwlat", value: "\(northWest.latitude)"),
            .init(name: "selat", value: "\(southEast.latitude)"),
            .init(name: "nwlng", value: "\(northWest.longitude)"),
            .init(name: "selng", value: "\(southEast.longitude)"),
            .init(name: "fields", value: "pm_1")
        ]
        guard let url = components.url else {
            print("Could not create URL from components: \(components)")
            return
        }
        // there seems to be an issue with `opt` as a URLQueryItem
        // so using a hack instead
//        let urlString = "https://www.purpleair.com/data.json?opt=1/i/mAQI/a10/cC0&fetch=true&nwlat=\(northWest.latitude)&selat=\(southEast.latitude)&nwlng=\(northWest.longitude)&selng=\(southEast.longitude)&fields=pm_1"
//        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        print("Fetching Sensor List: \(url)")
        let task = session?.downloadTask(with: request)
        task?.resume()
    }
    
    private var components: URLComponents? {
        URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
    }
}

final class SessionManager: NSObject {
    
}

extension PurpleAPIClient: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let originalURL = downloadTask.currentRequest?.url,
            let components = URLComponents(url: originalURL, resolvingAgainstBaseURL: true),
            let data = try? Data(contentsOf: location) else {
            NSLog("Bailing out \(downloadTask)")
            return
        }
        
        
        switch components.urlPath {
        case .fetchSensor:
            guard components[.fetchSensor] != nil else {
                NSLog("No sensorId found")
                return
            }
            do {
                let sensorResponse = try self.decoder.decode(PurpleSensorResponse.self, from: data)
                UserDefaults.lastSensorResponse = sensorResponse
                #if os(watchOS)
                updateComplications()
                #endif
            } catch {
                let string = String(data: data, encoding: .utf8)
                NSLog("urlSession downloadTask error \(error): \(String(describing: string))")
            }
        case .fetchSensorList:
            do {
                let sensorList = try self.decoder.decode(SensorList.self, from: data)
                print("sensorList: \(sensorList)")
                let sensors = sensorList.sensors
                print("sensors: \(sensors)")
            } catch {
                let string = String(data: data, encoding: .utf8)
                NSLog("urlSession downloadTask error \(error) \(String(describing: string))")
            }
        case .none:
            break
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            NSLog("urlSession task didCompleteWithError: \(task) \(error)")
        } else {
            NSLog("urlSession task didComplete: \(task)")
        }
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        NSLog("urlSession didBecomeInvalidWithError: \(String(describing: error))")
    }
    
    #if !os(macOS)
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        NSLog("urlSessionDidFinishEvents forBackgroundURLSession \(session)")
    }
    #endif

}

private extension PurpleAPIClient {
#if os(watchOS)
    func updateComplications() {
        let complicationServer = CLKComplicationServer.sharedInstance()
        guard let active = complicationServer.activeComplications else {
            return
        }
        for complication in active  {
            complicationServer.reloadTimeline(for: complication)
        }
    }
#endif
}


private extension URLComponents {
    var urlPath: URLPath? {
        get {
            return URLPath(rawValue: path)
        }
        set {
            path = newValue?.rawValue ?? ""
        }
    }
    
    subscript(queryParam:URLQuery) -> String? {
        return queryItems?.first(where: { $0.name == queryParam.rawValue })?.value
    }
}

private enum URLPath: String {
    case fetchSensor = "/json"
    case fetchSensorList = "/data.json"
    
    func url(baseURL: URL) -> URL {
        return baseURL.appendingPathComponent("\(rawValue)")
    }
}

private enum URLQuery: String {
    case fetchSensor = "show"
    
    func queryItem(value: String?) -> URLQueryItem {
        return URLQueryItem(name: rawValue, value: value)
    }
}

extension URLSessionConfiguration {
    static let purple = URLSessionConfiguration.background(withIdentifier: "io.ballinger.PurpleAPI")
}
