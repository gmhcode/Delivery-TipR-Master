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
    static let secondsInYear : Double = 31536000
    static let secondsInMonth : Double = 2592000
    static let secondsInWeek : Double = 604800
    static let secondsInDay : Double = 86400
    
    ///Creates a delivery with the address as the same address as the location
    static func createDelivery(for location: Location, trip: Trip) -> Delivery {
        let persistentManager = PersistenceManager.shared
        let delivery = Delivery(context: persistentManager.context)
        
        delivery.userID = UserController.fetchUser()?.uuid ?? "ID NotWorking"
        delivery.unlocked = 1
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
    
  
    
    
    static func editDelivery(delivery: Delivery, phoneNumber: String, tipAmount: Float, address : String )  {
        let persistentManager = PersistenceManager.shared
        delivery.locationId = phoneNumber
        delivery.tipAmonut = tipAmount
        delivery.address = address
        
        persistentManager.saveContext()
        
//        return delivery
//        let location = LocationController.getExistingLocation(address: address)
//        let deliv = getDeliveryWith(id: delivery.id)[0]
//        print(deliv.tipAmonut," 🚣🏼‍♂️")
    }
    
    static func getDeliveryWith(id:String) -> [Delivery] {
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Delivery> = Delivery.fetchRequest()
        let predicate = NSPredicate(format: "id == %@ AND unlocked == 1",id)
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
    
    static func getALLDeliveries() -> [Delivery] {
        let persistentManager = PersistenceManager.shared
        let deliveries = persistentManager.fetch(Delivery.self)
        printDeliveries()
        return deliveries
    }
    
    static func getTripDeliveries(trip: Trip)-> [Delivery] {
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Delivery> = Delivery.fetchRequest()
        let predicate = NSPredicate(format: "tripId == %@ AND unlocked == 1", trip.id)
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
        let predicate = NSPredicate(format: "tripId == %@ AND isFinished == 0 AND unlocked == 1", trip.id)
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
        let predicate = NSPredicate(format: "locationId CONTAINS[cd] %@ AND isFinished == 0 AND unlocked == 1", location.id)
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
    
    static func getFinishedDeliveries(trip: Trip) -> [Delivery] {
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Delivery> = Delivery.fetchRequest()
        let predicate = NSPredicate(format: "tripId CONTAINS[cd] %@ AND isFinished == 1 AND unlocked == 1", trip.id)
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
    
    ///Gets all the finished deliveries for a location
    static func getFinishedDeliveries(for location: Location) -> [Delivery] {
        
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Delivery> = Delivery.fetchRequest()
        let predicate = NSPredicate(format: "locationId CONTAINS[cd] %@ AND isFinished == 1 AND unlocked == 1", location.id)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
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
    
    ///Gets all the finished deliveries for a location
        static func getAllFinishedDeliveries() -> [Delivery] {
            
            let persistentManager = PersistenceManager.shared
            let request : NSFetchRequest<Delivery> = Delivery.fetchRequest()
            let predicate = NSPredicate(format: "isFinished == 1 AND unlocked == 1")
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
//        print(delivery.isFinished, " finished Delivery with address \(delivery.address)")
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
    
    // MARK: - AdvancedViewController Functions
    #warning("UNWRAP USER")
    static func fetchTodaysDeliveries() -> [Delivery]? {
        let user = UserController.fetchUser()!
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Delivery> = Delivery.fetchRequest()
        let date = Date().timeIntervalSince1970 - (secondsInDay * 2)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = NSPredicate(format: "date >= \(date) AND isFinished == 1 AND unlocked == 1 AND userID == %@", user.uuid)
         
        
        do {
            var deliveries = try persistentManager.context.fetch(request)
            deliveries = deliveries.filter({Date(timeIntervalSince1970: $0.date).isInToday})
            return deliveries
        } catch  {
            print("array could not be retrieved \(error)")
            return nil
        }
    }
    
    
    static func fetchThisWeeksDeliveries() -> [Delivery]? {
        let user = UserController.fetchUser()!
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Delivery> = Delivery.fetchRequest()
        let date = Date().timeIntervalSince1970 - (secondsInWeek + secondsInDay)
        let predicate = NSPredicate(format: "date >= \(date) AND unlocked == 1 AND isFinished == 1 AND userID == %@", user.uuid)
        request.predicate = predicate
        
        do {
            var deliveries = try persistentManager.context.fetch(request)
            deliveries = deliveries.filter({Date(timeIntervalSince1970: $0.date).isInThisWeek})
            return deliveries
        } catch  {
            print("array could not be retrieved \(error)")
            return nil
        }
    }
    
    static func fetchThisMonthsDeliveries() -> [Delivery]? {
        let user = UserController.fetchUser()!
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Delivery> = Delivery.fetchRequest()
        let date = Date().timeIntervalSince1970 - (secondsInMonth + secondsInWeek)
        let predicate = NSPredicate(format: "date >= \(date) AND unlocked == 1 AND isFinished == 1 AND userID == %@", user.uuid)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = predicate
        
        do {
            var deliveries = try persistentManager.context.fetch(request)
            deliveries = deliveries.filter({Date(timeIntervalSince1970: $0.date).isInThisMonth})
            return deliveries
        } catch  {
            print("array could not be retrieved \(error)")
            return nil
        }
    }
    
    static func fetchThisYearsDeliveries() -> [Delivery]? {
        let user = UserController.fetchUser()!
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Delivery> = Delivery.fetchRequest()
        let date = Date().timeIntervalSince1970 - (secondsInYear + secondsInMonth)
        let predicate = NSPredicate(format: "date >= \(date) AND unlocked == 1 AND isFinished == 1 AND userID == %@", user.uuid)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = predicate
        
        do {
            var deliveries = try persistentManager.context.fetch(request)
            deliveries = deliveries.filter({Date(timeIntervalSince1970: $0.date).isInThisYear})
            return deliveries
        } catch  {
            print("array could not be retrieved \(error)")
            return nil
        }
    }
    
    static func fetchAllDeliveries() -> [Delivery]? {
        let user = UserController.fetchUser()!
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Delivery> = Delivery.fetchRequest()
        let predicate = NSPredicate(format: "unlocked == 1 AND isFinished == 1 AND userID == %@", user.uuid)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = predicate
        
        do {
            var deliveries = try persistentManager.context.fetch(request)
            deliveries = deliveries.filter({Date(timeIntervalSince1970: $0.date).isInThisYear})
            return deliveries
        } catch  {
            print("array could not be retrieved \(error)")
            return nil
        }
    }
}
