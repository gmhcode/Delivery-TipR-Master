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
    
    static func setUpTestDeliveries() -> [Delivery] {
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
                
                finishedD.date -= (secondsInMonth * 2)
                thisYear.append(delivery)
                
            }
            else if index % 3 == 0 {
                
                finishedD.date -= secondsInWeek 
                thisMonth.append(delivery)
                
            }
            else if index % 2 == 0 {
                finishedD.date -=  (secondsInDay * 2)
                thisWeek.append(delivery)
                
            } else {
                today.append(delivery)
                
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
