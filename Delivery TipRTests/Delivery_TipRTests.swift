//
//  Delivery_TipRTests.swift
//  Delivery TipRTests
//
//  Created by Greg Hughes on 3/1/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import XCTest
@testable import Delivery_TipR

class Delivery_TipRTests: XCTestCase {
    
    var today : Double = 0.0
    var yesterday : Double = 0.0
    var lastWeek : Double = 0.0
    var lastMonth : Double = 0.0
    var lastYear : Double = 0.0
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let secondsInYear : Double = 31536000
        let secondsInMonth : Double = 2592000
        let secondsInWeek : Double = 604800
        let secondsInDay : Double = 86400
        let _ : Double = 3600
        let _ : Double = 60
        
        let today = Date().timeIntervalSince1970
        yesterday = today - secondsInDay
        lastWeek = today - secondsInWeek
        lastMonth = today - secondsInMonth
        lastYear = today - secondsInYear
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
