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
    
//    static let shared = LocationController()
//    private let persistentManager = PersistenceManager.shared
//    var locations : [Location] = []
    
    
    //Create
    
    static func createLocation(address: String, latitude: Double, longitude: Double, subAddress: String) {
        let persistentManager = PersistenceManager.shared
        let location = Location(context: persistentManager.context)
        location.address = address
        location.averageTip = 0
        location.confirmed = 0
        location.id = address
        location.latitude = latitude
        location.longitude = longitude
        location.subAddress = subAddress
        persistentManager.saveContext()
        
    }
    
    
    
    ///use only for tests
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
        print(locations.count, " getALLLocations ⚡️")
        return locations
    }
    
    /// Find a location with a specific address
    static func getLocation(with address: String) -> Location?{
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Location> = Location.fetchRequest()
        let predicate = NSPredicate(format: "address CONTAINS[cd] %@", address)
        request.predicate = predicate
        
        do {
            let locations = try persistentManager.context.fetch(request)
            print(locations," 🤣 RETREIVED")
            return locations[0]
        } catch  {
            print("array could not be retrieved \(error)")
            return nil
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
        print("locations Delete ⛽️")
        printLocation()
        persistentManager.saveContext()
    }
    
    
    
    // Find the Unfinished Delivery
    func findUnfinishedDelivery() {
        
    }
    
    
}
