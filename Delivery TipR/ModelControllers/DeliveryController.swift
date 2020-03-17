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
    
    ///Creates a delivery with the address as the same address as the location
    static func createDelivery(for location: Location, trip: Trip) -> Delivery {
        let persistentManager = PersistenceManager.shared
        let delivery = Delivery(context: persistentManager.context)
        
        delivery.id = UUID().uuidString
        delivery.address = location.address
        delivery.locationId = location.id
        delivery.isFinished = 0
        delivery.tripId = trip.id
        delivery.date = Date().timeIntervalSince1970 
        print(delivery.tipAmonut, " ❗️")
        persistentManager.saveContext()
        
        return delivery
    }
    
    
    
    
    static func getALLDeliveries() -> [Delivery] {
        let persistentManager = PersistenceManager.shared
        let deliveries = persistentManager.fetch(Delivery.self)
        printDeliveries()
        return deliveries
    }
    
    static func getTripDeliveries(trip: Trip)-> [Delivery] {
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Delivery> = Delivery.fetchRequest()
        let predicate = NSPredicate(format: "tripId == %@", trip.id)
        request.predicate = predicate
        
        do {
            let deliveries = try persistentManager.context.fetch(request)
//            print(deliveries,"getTripDeliveries ❇️")
            return deliveries
        } catch  {
            print("array could not be retrieved \(error)")
            return []
        }
    }
    
    static func getUnfinishedTripDeliveries(trip: Trip)-> [Delivery] {
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Delivery> = Delivery.fetchRequest()
        let predicate = NSPredicate(format: "tripId == %@ AND isFinished == 0", trip.id)
        request.predicate = predicate
        
        do {
            let deliveries = try persistentManager.context.fetch(request)
//            print(deliveries,"getTripDeliveries ❇️")
            return deliveries
        } catch  {
            print("array could not be retrieved \(error)")
            return []
        }
    }
    /// Deletes all the unfinished deliveries for the specified trip
    static func deleteUnFinDelFor(trip:Trip) {
        let persistentManager = PersistenceManager.shared
        let deliveries = getUnfinishedTripDeliveries(trip: trip)
        for i in deliveries {
            persistentManager.delete(i)
        }
        print("Deliveries Delete for Trip ⛵️")
        persistentManager.saveContext()
    }
    
    static func deleteDelivery(deliveries:[Delivery]) {
        let persistentManager = PersistenceManager.shared
        for i in deliveries {
            persistentManager.delete(i)
        }
        print("Deliveries Delete⛵️")
        persistentManager.saveContext()
    }
    
    
    static func printDeliveries() {
        let persistentManager = PersistenceManager.shared
        let deliveries = persistentManager.fetch(Delivery.self)
        deliveries.forEach({print($0.address, " Deliveries 🌹")})
    }
    
    
    /// Finds all the deliveries with the same address as the location with the isFinished == 0 (false)
    static func getUnfinishedDeliveries(for location: Location) -> [Delivery] {
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Delivery> = Delivery.fetchRequest()
        let predicate = NSPredicate(format: "locationId CONTAINS[cd] %@ AND isFinished == 0", location.id)
        request.predicate = predicate
        
        do {
            let deliveries = try persistentManager.context.fetch(request)
            print(deliveries,"GetUnfinishedDelivery ❇️")
            return deliveries
        } catch  {
            print("array could not be retrieved \(error)")
            return []
        }
    }
    ///Gets all the finished deliveries for a location
    static func getFinishedDeliveries(for location: Location) -> [Delivery] {
        
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Delivery> = Delivery.fetchRequest()
        let predicate = NSPredicate(format: "locationId CONTAINS[cd] %@ AND isFinished == 1", location.id)
        request.predicate = predicate
        
        do {
            let deliveries = try persistentManager.context.fetch(request)
//            print(deliveries.count,"Get Finished Deliveries 🥶")
            return deliveries
        } catch  {
            print("array could not be retrieved \(error)")
            return []
        }
    }
    
    /// Finishes the delivery, adds the tip amount and saves
    static func finishDelivery(delivery: Delivery, tipAmount: Float) -> Delivery {
        let persistentManager = PersistenceManager.shared
        delivery.isFinished = 1
        delivery.tipAmonut = tipAmount
        persistentManager.saveContext()
        print(delivery.isFinished, " finished Delivery with address \(delivery.address)")
        return delivery
    }
    
    /// unFinishes the delivery, removes the tip amount and saves
    static func unFinishDelivery(delivery: Delivery) -> Delivery{
        let persistentManager = PersistenceManager.shared
        delivery.isFinished = 0
        delivery.tipAmonut = 0
        persistentManager.saveContext()
        return delivery
    }
    
    ///Deletes all of the deliveries
    static func deleteALLDeliveries(){
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
