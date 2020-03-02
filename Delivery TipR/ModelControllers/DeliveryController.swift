//
//  DeliveryController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/2/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation
import CoreData

class DeliveryController {
    
//    static let persistentManager = PersistenceManager.shared
    
    static func createDelivery(for location: Location) -> Delivery {
        let persistentManager = PersistenceManager.shared
        let delivery = Delivery(context: persistentManager.context)
        
        delivery.id = UUID().uuidString
        delivery.address = location.address
        delivery.locationId = location.id
        persistentManager.saveContext()
        
        return delivery
    }
    static func getALLDeliveries() -> [Delivery]{
        let persistentManager = PersistenceManager.shared
        
        let deliveries = persistentManager.fetch(Delivery.self)
        printDeliveries()
        return deliveries
        
    }
    
    static func printDeliveries() {
        let persistentManager = PersistenceManager.shared
        let deliveries = persistentManager.fetch(Delivery.self)
        deliveries.forEach({print($0.address, " Deliveries 🌹")})
    }
    
    static func deleteDeliveries(){
        let persistentManager = PersistenceManager.shared
        let deliveries = getALLDeliveries()
        for i in deliveries {
            persistentManager.delete(i)
        }
        print("Deliveries Delete ⛵️")
        printDeliveries()
        persistentManager.saveContext()
    }
}
