//
//  PurpleAPITests.swift
//  PurpleWatchTests
//
//  Created by Chris Ballinger on 11/17/18.
//  Copyright © 2018 Chris Ballinger. All rights reserved.
//

import XCTest
@testable import PurpleAPI

final class PurpleAPITests: XCTestCase {
    
    let decoder = JSONDecoder()

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testDecodeSensor() throws {
        let response: PurpleSensorResponse = try decodeResource(Fixtures.sensor)
        XCTAssertEqual(response.results.count, 2)
    }
    
    func testDecodeStats() throws {
        let response: PurpleSensor.Stats = try decodeResource(Fixtures.stats)
        XCTAssertEqual(response.pm, 105.62)
    }
    
    func testMeasurement() throws {
        let pm25 = PM25(55.0)
        let gpl = pm25.measurementValue.converted(to: UnitConcentrationMass.gramsPerLiter)
        XCTAssertEqual("5.5e-08 g/L", gpl.description)
    }
    
    func testDecodeSensorList() throws {
        // https://www.purpleair.com/data.json?opt=1/i/mAQI/a10/cC0&fetch=true&nwlat=37.95280545255774&selat=37.723966026666204&nwlng=-122.43809247307286&selng=-122.23587537102202&fields=pm_1
        let list: SensorList = try decodeResource(Fixtures.sensorList)
        XCTAssertEqual(list.count, 1)
        let sensors = list.sensors
        XCTAssertEqual(list.count, sensors.count)
    }
    
    static var allTests = [
        ("testDecodeSensor", testDecodeSensor),
        ("testDecodeStats", testDecodeStats),
        ("testMeasurement", testMeasurement),
    ]
}

private extension PurpleAPITests {
    func decodeResource<T: Decodable>(_ resource: String) throws -> T {
        let data = try XCTUnwrap(resource.data(using: .utf8))
        let object = try decoder.decode(T.self, from: data)
        return object
    }
}
