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
    
    static let shared = LocationController()
    private let persistentManager = PersistenceManager.shared
    var locations : [Location] = []
    
    
    //Create
    func createLocation() {
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
    func getALLLocations() -> [Location] {
        let locations = persistentManager.fetch(Location.self)
        self.locations = locations
        printLocation()
        return locations
    }
    
    
    func getLocation(with address: String) {
        let request : NSFetchRequest<Location> = Location.fetchRequest()
        let predicate = NSPredicate(format: "address CONTAINS[cd] %@", address)
        request.predicate = predicate
        
        do {
            let array = try persistentManager.context.fetch(request)
            print(array," 🤣 RETREIVED")
        } catch  {
            print("array could not be retrieved \(error)")
        }
    }
    
    
    
    
    func printLocation() {
        self.locations.forEach({print($0.address)})
    }
    
    
    //Update
    
    
    
    //Delete
    func deleteDatabase() {
        let locations = getALLLocations()
        for i in locations {
            persistentManager.delete(i)
        }
    }
    
    
    
    // Find the Unfinished Delivery
    func findUnfinishedDelivery() {
        
    }
    
    
}
