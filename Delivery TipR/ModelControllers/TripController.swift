//
//  TripController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/5/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation
import CoreData
class TripController {
    
    
    
    func createNewTrip() -> Trip {
        let persistentManager = PersistenceManager.shared
        
        //Set the current trip to false
        let currentTrip = getCurrentTrip()
        if currentTrip.isEmpty == false {
            currentTrip[0].isCurrent = 0
            
        }
        
        //Set a new current trip
        let trip = Trip(context: persistentManager.context)
        trip.date = Date()
        trip.id = UUID().uuidString
        trip.isCurrent = 1
        persistentManager.saveContext()
        return trip
    }
    
    
    
    ///Fetches and returns the current Trip
    func getCurrentTrip() -> [Trip] {
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Trip> = Trip.fetchRequest()
        let predicate = NSPredicate(format: "isCurrent == 1")
        request.predicate = predicate
        do {
            let trips = try persistentManager.context.fetch(request)
            return trips
        } catch  {
            print("array could not be retrieved \(error)")
            return []
        }
    }
    
    private func getAllTrips() -> [Trip] {
        let persistentManager = PersistenceManager.shared
        let trips = persistentManager.fetch(Trip.self)
        print(trips.count, "Trips ♊️")
        return trips
    }
    func deleteTrips() {
        let persistentManager = PersistenceManager.shared
        
        let trips = getAllTrips()
        for i in trips {
            persistentManager.delete(i)
        }
        print("Trips Delete")
        persistentManager.saveContext()
    }
}
