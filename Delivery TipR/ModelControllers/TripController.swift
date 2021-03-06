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
    
    
    ///Finished the current trip, makes a new trip, makes that new trip the current trip
    static func createNewTrip() -> Trip {
        let persistentManager = PersistenceManager.shared
        
        //Set the current trip to false
        if let currentTrip = getCurrentTrip() {
            currentTrip.isCurrent = 0
        }
        
        //Set a new current trip
        let trip = Trip(context: persistentManager.context)
        trip.date = Date().timeIntervalSince1970
        trip.id = UUID().uuidString
        trip.isCurrent = 1
        persistentManager.saveContext()
        return trip
    }
    
    static func createTripFromDownload(date: Double, id : String ) -> Trip? {
        let persistentManager = PersistenceManager.shared
        let existingTrip = getTrip(from: id)
        if existingTrip.isEmpty{
            
            let trip = Trip(context: persistentManager.context)
            trip.date = date
            trip.id = id
            trip.isCurrent = 0
            persistentManager.saveContext()
            return trip
            
        }
        return nil
    }
    
    
    ///Get Trip from delivery
    static func getTrip(from tripId: String) -> [Trip] {
          let persistentManager = PersistenceManager.shared
          let request : NSFetchRequest<Trip> = Trip.fetchRequest()
          let predicate = NSPredicate(format: "id == %@", tripId)
          request.predicate = predicate
          
          do {
              let trips = try persistentManager.context.fetch(request)
              return trips
          } catch  {
              print("array could not be retrieved \(error)")
              return []
          }
      }
    
    ///Fetches and returns the current Trip, if there is no current trip
    static func getCurrentTrip() -> Trip? {
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Trip> = Trip.fetchRequest()
        let predicate = NSPredicate(format: "isCurrent == 1")
        request.predicate = predicate
        do {
            let trips = try persistentManager.context.fetch(request)
            if !trips.isEmpty {
                return trips[0]
            }
            return nil
        } catch  {
            print("array could not be retrieved \(error)")
            return nil
        }
    }
    
    private func getAllTrips() -> [Trip] {
        let persistentManager = PersistenceManager.shared
        let trips = persistentManager.fetch(Trip.self)
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
