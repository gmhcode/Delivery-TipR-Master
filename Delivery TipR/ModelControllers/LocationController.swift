//
//  LocationController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/1/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation
import CoreData

class LocationController {
    

    //Create
    
    /// If the location already exists in the database, it will return that location. If not, it will return a new location.
    @discardableResult static func createLocation(address: String, latitude: Double, longitude: Double, subAddress: String, phoneNumber: String) -> Location {
        
        let persistentManager = PersistenceManager.shared
        
        
        if let location = getExistingLocation(phoneNumber: phoneNumber) {
//            let location = existingLocation
            if location.address != address {
                location.address = address
                location.subAddress = subAddress
                location.latitude = latitude
                location.longitude = longitude
                location.phoneNumber = phoneNumber
                location.id = phoneNumber
                persistentManager.saveContext()
            }
            return location
        }
        let location = Location(context: persistentManager.context)
        location.address = address
        location.averageTip = 0
        location.confirmed = 0
        location.id = phoneNumber
        location.phoneNumber = phoneNumber
        location.latitude = latitude
        location.longitude = longitude
        location.subAddress = subAddress
        persistentManager.saveContext()
        return location
    }
    
    static func editLocationPhone(location: Location,phoneNumber: String) {
        let persistentManager = PersistenceManager.shared
        location.phoneNumber = phoneNumber
        persistentManager.saveContext()

    }
    
    ///Use only for tests
    private func createLocationFake() {
        let persistentManager = PersistenceManager.shared
        let location = Location(context: persistentManager.context)
        location.address = "address test 1"
        location.averageTip = 0
        location.confirmed = 1
        location.id = "address test 1"
        location.latitude = 123
        location.longitude = 123
        location.subAddress = "subAddress test 1"
        persistentManager.saveContext()
    }
    //Get
    static func getALLLocations() -> [Location] {
        let persistentManager = PersistenceManager.shared
        let locations = persistentManager.fetch(Location.self)
        //        print(locations.count, " getALLLocations ⚡️")
        return locations
    }
    
    /// Find a location with a specific address
    static func getExistingLocation(phoneNumber: String) -> Location? {
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Location> = Location.fetchRequest()
        let predicate = NSPredicate(format: "id CONTAINS[cd] %@", phoneNumber)
        request.predicate = predicate
        
        do {
            let locations = try persistentManager.context.fetch(request)
            
            if locations.count > 0 {
                return locations[0]
            }
            
            return nil
        } catch  {
            print("array could not be retrieved \(error)")
            return nil
        }
    }
    
    /// Find a location with a specific address
    static func getExistingLocation(address: String) -> [Location] {
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Location> = Location.fetchRequest()
        let predicate = NSPredicate(format: "address CONTAINS[cd] %@", address)
        request.predicate = predicate
        
        do {
            let locations = try persistentManager.context.fetch(request)
            //            print(locations," 🤣 RETREIVED")
            return locations
        } catch  {
            print("array could not be retrieved \(error)")
            return []
        }
    }
    
    static func printLocation() {
        let locations = getALLLocations()
        locations.forEach({print($0.address, " Locations ⛽️")})
    }
    
    
    //Delete
    static func deleteDatabase() {
        let persistentManager = PersistenceManager.shared
        let locations = getALLLocations()
        for i in locations {
            persistentManager.delete(i)
        }
//        print("locations Delete ⛽️")
        printLocation()
        persistentManager.saveContext()
    }
    
    /// Loops through all the finished deliveries, gets the average tip, sets that to the location.
    static func setAverageTipFor(location:Location) {
        let persistentManager = PersistenceManager.shared
        let finishedDeliveries = DeliveryController.getFinishedDeliveries(for: location)
        // Gets all the deliveries' tips and adds them together
        let averageTip = finishedDeliveries.map({$0.tipAmount}).reduce(0,+) / Float(finishedDeliveries.count)
        location.averageTip = Double(averageTip)
        persistentManager.saveContext()
//        let retrievedLoc = getLocation(with: location.address)
//        print(retrievedLoc[0].averageTip," fetched average tip 🏵")
    }
}
