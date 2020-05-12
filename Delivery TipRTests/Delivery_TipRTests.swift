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
    
    let address = 0
    let latitude = 0
    let longitude = 0
    let subAddress = 0
    let phoneNumber = 0
    
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
        
        DeliveryController.deleteALLDeliveries()
        LocationController.deleteDatabase()
        TripController().deleteTrips()
    }
    ///Simple test that the createLocation() function has the same properties as when they were entered
    func testCreateLocation() {
        
        let location = LocationController.createLocation(address: String(address), latitude: Double(latitude), longitude: Double(longitude), subAddress: String(subAddress), phoneNumber: String(phoneNumber))
        
        let testBool = Int(location.address) == address
            && Int(location.latitude) == latitude
            && Int(location.longitude) == longitude
            && Int(location.subAddress) == subAddress
            && Int(location.phoneNumber) == phoneNumber
        
        LocationController.deleteDatabase()
        
        XCTAssertTrue(testBool)
    }
    /// Tests to make sure two locations aren't created with the same phone Number
    func testExistingCreateLocation() {
        
        LocationController.createLocation(address: String(address), latitude: Double(latitude), longitude: Double(longitude), subAddress: String(subAddress), phoneNumber: String(phoneNumber))
        
        let location2 = LocationController.createLocation(address: String(address + 1), latitude: Double(latitude + 1), longitude: Double(longitude + 1), subAddress: String(subAddress + 1), phoneNumber: String(phoneNumber))
        
        
        let testBool = LocationController.getALLLocations().count == 1 && Int(location2.address) == address + 1
        && Int(location2.latitude) == latitude + 1
        && Int(location2.longitude) == longitude + 1
        && Int(location2.subAddress) == subAddress + 1
        && Int(location2.phoneNumber) == phoneNumber
        
        LocationController.deleteDatabase()
        
        XCTAssertTrue(testBool)
    }
    
    func testGetExistingLocation() {
         
        let location = LocationController.createLocation(address: String(address), latitude: Double(latitude), longitude: Double(longitude), subAddress: String(subAddress), phoneNumber: String(phoneNumber))
        
        let fetchedLocation = LocationController.getExistingLocation(phoneNumber: location.phoneNumber)[0]
        
        let testBool = Int(fetchedLocation.address) == address
        && Int(fetchedLocation.latitude) == latitude
        && Int(fetchedLocation.longitude) == longitude
        && Int(fetchedLocation.subAddress) == subAddress
        && Int(fetchedLocation.phoneNumber) == phoneNumber
        
//        LocationController.deleteDatabase()
        tearDown()
        XCTAssertTrue(testBool)
        
    }
    
    func testGetExistingLocationAddress() {
        let location = LocationController.createLocation(address: String(address), latitude: Double(latitude), longitude: Double(longitude), subAddress: String(subAddress), phoneNumber: String(phoneNumber))
        
        let fetchedLocation = LocationController.getExistingLocation(address: location.address)[0]
        
        let testBool = Int(fetchedLocation.address) == address
        && Int(fetchedLocation.latitude) == latitude
        && Int(fetchedLocation.longitude) == longitude
        && Int(fetchedLocation.subAddress) == subAddress
        && Int(fetchedLocation.phoneNumber) == phoneNumber
        
//        LocationController.deleteDatabase()
        tearDown()
        XCTAssertTrue(testBool)
    }
    ///checks to see if the setAverageTip function works
    func testSetAverageTipForLocation(){
        if  TripController.getCurrentTrip() == nil {
            let _ = TripController.createNewTrip()
        }
        let location = LocationController.createLocation(address: String(address), latitude: Double(latitude), longitude: Double(longitude), subAddress: String(subAddress), phoneNumber: String(phoneNumber))
        let delivery1 = DeliveryController.createDelivery(for: location, trip: TripController.getCurrentTrip()!)
        let delivery2 = DeliveryController.createDelivery(for: location, trip: TripController.getCurrentTrip()!)
        
        
        DeliveryController.finishDelivery(delivery: delivery1, tipAmount: 0)
        DeliveryController.finishDelivery(delivery: delivery2, tipAmount: 4)
        LocationController.setAverageTipFor(location: location)
        let testBool = LocationController.getExistingLocation(phoneNumber: location.phoneNumber)[0].averageTip == 2
        tearDown()
        XCTAssertTrue(testBool)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    

    func testRemoveCommasAnd$() {
        var theString = "$123,123,123.00"
        theString = theString.removeCommasAnd$()
        let testBool = theString == "123123123.00"
        XCTAssertTrue(testBool)
        
    }

}
