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

public class PurpleAPIClient: NSObject {
    private var session: URLSession?
    private let decoder = JSONDecoder()
    private let baseURL = URL(string: "https://www.purpleair.com/")!
    public static let shared = PurpleAPIClient()
    
    public override init() {
        super.init()
        self.session = URLSession(configuration: .purple, delegate: self, delegateQueue: nil)
    }
    
    public func fetchSensor(id: Int) {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
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
        let task = session?.downloadTask(with: request)
        task?.resume()
    }
}

final class SessionManager: NSObject {
    
}

extension PurpleAPIClient: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let originalURL = downloadTask.originalRequest?.url,
            let components = URLComponents(url: originalURL, resolvingAgainstBaseURL: true),
            let path = components.urlPath else {
            NSLog("Bailing out \(downloadTask)")
            return
        }
        switch path {
        case .fetchSensor:
            guard components[.fetchSensor] != nil else {
                NSLog("No sensorId found")
                return
            }
            do {
                let data = try Data(contentsOf: location)
                let sensorResponse = try self.decoder.decode(PurpleSensorResponse.self, from: data)
                UserDefaults.lastSensorResponse = sensorResponse
                #if os(watchOS)
                updateComplications()
                #endif
            } catch {
                NSLog("urlSession downloadTask error \(error)")
            }
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
