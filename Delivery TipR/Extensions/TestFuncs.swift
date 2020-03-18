//
//  TestFuncs.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/16/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation
import MapKit
import Contacts
import CoreData
struct TestFuncs {
    
    static let secondsInYear : Double = 31536000
    static let secondsInMonth : Double = 2592000
    static let secondsInWeek : Double = 604800
    static let secondsInDay : Double = 86400
    static var dictionary : [String:Trip] = [:]
    var incrementDay = 0
    var incrementWeek = 0
    var incrementMonth = 0
    var incrementYear = 0
    
    
    static func newTestTrip(date: Double) -> Trip {
        ///Finished the current trip, makes a new trip, makes that new trip the current trip
        let persistentManager = PersistenceManager.shared
        //Set a new current trip
        let trip = Trip(context: persistentManager.context)
        trip.date = date
        trip.id = UUID().uuidString
        trip.isCurrent = 0
        persistentManager.saveContext()
        return trip
    }
    func thisYearInterval() ->Double {
        return 0.000
    }
    func thisMonthInterval() ->Double {
        return 0.000
    }
    func thisWeekInterval() ->Double {
        return 0.000
    }
    
    static func setupTestTrips() {
        if dictionary["thisYear"] != nil {return}
        dictionary["thisYear"] = newTestTrip(date: Date().timeIntervalSince1970 - (secondsInMonth * 2))
        dictionary["thisMonth"] = newTestTrip(date: Date().timeIntervalSince1970 - (secondsInWeek * 2))
        dictionary["thisWeek"] = newTestTrip(date: (Date().timeIntervalSince1970 - (secondsInDay * 2)))
        dictionary["today"] = newTestTrip(date: Date().timeIntervalSince1970)
    }
    
    
    
    
    static func setUpTestDeliveries() -> [Delivery] {
        setupTestTrips()
        let persistentManager = PersistenceManager.shared
        let deliveries = persistentManager.fetch(Delivery.self)
        var thisYear : [Any] = []
        var thisMonth : [Any] = []
        var thisWeek : [Any] = []
        var today: [Any] = []
        
        print(deliveries.count, "DeliveryCount 🎷")
        for (index,delivery) in deliveries.enumerated() {
            let finishedD = DeliveryController.finishDelivery(delivery: delivery, tipAmount: Float(index))
            
            if index % 5 == 0 {
                if dictionary["thisYear"] != nil {
                    finishedD.date = dictionary["thisYear"]!.date
                    finishedD.tripId = dictionary["thisYear"]!.id
                    thisYear.append(delivery)
                }
            }
            else if index % 3 == 0 {
                if dictionary["thisMonth"] != nil {
                    finishedD.date = dictionary["thisMonth"]!.date
                    finishedD.tripId = dictionary["thisMonth"]!.id
                    thisMonth.append(delivery)
                }
                
            }
            else if index % 2 == 0 {
                if dictionary["thisWeek"] != nil {
                    finishedD.date = dictionary["thisWeek"]!.date
                    finishedD.tripId = dictionary["thisWeek"]!.id
                    thisWeek.append(delivery)
                }
                
            } else {
                if dictionary["today"] != nil {
                    finishedD.date = dictionary["today"]!.date
                    finishedD.tripId = dictionary["today"]!.id
                    today.append(delivery)
                }
                
            }
        }
        print("this Year Deliveries 🧗🏾 ", thisYear.count)
        print("this day Deliveries 🧩 ", today.count)
        print("this week Deliveries 🎰 ", thisWeek.count)
        print("this month Deliveries 🎳 ", thisMonth.count)
        persistentManager.saveContext()
        return deliveries
    }
    
    static func populateDeliveryTests(indexPath: IndexPath, searchResults: [MKLocalSearchCompletion]) {
        let searchResult = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: searchResult)
        let search = MKLocalSearch(request: searchRequest)

        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            let address = searchResults[indexPath.row].title
            let subAddress = searchResults[indexPath.row].subtitle
            guard let coordinateA = coordinate else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

            
            MapViewController.MapVC.addPin(coord: coordinateA, address: address, apt: nil, subAddress: subAddress)
        }
    }
}
