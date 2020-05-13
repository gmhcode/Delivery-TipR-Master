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
        delivery.latitude = String(location.latitude)
        delivery.longitude = String(location.longitude)
        print(delivery.tipAmount, " ❗️")
        persistentManager.saveContext()
        
        return delivery
    }
    
    static func createDelivery(userId : String, id: String, address : String, locationId: String, tripId: String, date : String, latitude: String, longitude: String, tipAmount: Float){
        let persistentManager = PersistenceManager.shared
        let delivery = Delivery(context: persistentManager.context)
        
        delivery.userID = UserController.fetchUser()?.uuid ?? "ID NotWorking"
        delivery.unlocked = 1
        delivery.id = UUID().uuidString
        delivery.address = address
        delivery.locationId = locationId
        delivery.isFinished = 0
        delivery.tripId = tripId
        delivery.date = Double(date) ?? 0
        delivery.latitude = latitude
        delivery.longitude = longitude
        persistentManager.saveContext()
    }
    
    
    static func editDelivery(delivery: Delivery, phoneNumber: String, tipAmount: Float, address : String, latitude: String, longitude: String)  {
        let persistentManager = PersistenceManager.shared
        delivery.locationId = phoneNumber
        delivery.tipAmount = tipAmount
        delivery.address = address
        delivery.latitude = latitude
        delivery.longitude = longitude
        
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
    
    static func getFinishedTripDeliveries(trip: Trip)-> [Delivery] {
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<Delivery> = Delivery.fetchRequest()
        let predicate = NSPredicate(format: "tripId == %@ AND unlocked == 1 AND isFinished == 1", trip.id)
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
    
    
    static func getAllTripDeliveries(trip: Trip)-> [Delivery] {
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
    @discardableResult static func finishDelivery(delivery: Delivery, tipAmount: Float) -> Delivery {
        let persistentManager = PersistenceManager.shared
        delivery.isFinished = 1
        delivery.tipAmount = tipAmount
        persistentManager.saveContext()
        //        postDelivery(deliveries: [delivery])
        //        print(delivery.isFinished, " finished Delivery with address \(delivery.address)")
        return delivery
    }
    
    
    
    /// unFinishes the delivery, removes the tip amount and saves
    static func unFinishDelivery(delivery: Delivery) -> Delivery{
        let persistentManager = PersistenceManager.shared
        delivery.isFinished = 0
        delivery.tipAmount = 0
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
    
    
    
    // MARK: - BackEnd
    struct BackEnd {
        static func getParams(delivery: Delivery) -> [String:Any] {
            let params : [String : Any] = ["userID" : delivery.userID, "tipAmount": delivery.tipAmount, "address": delivery.address, "locationId": delivery.locationId, "id" : delivery.id, "isFinished" : delivery.isFinished, "tripId" : delivery.tripId, "date" : delivery.date, "latitude" : delivery.latitude, "longitude" : delivery.longitude]
            return params
        }
        
        static func fetchAllDeliveries(for user:User, completion: @escaping ([String: AnyObject]?) -> Void) {
            DispatchQueue.global(qos: .background).async {
                guard let url = BackEndUrls.getAllDeliveriesUrl(user: user) else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); completion(nil); return}
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription) : \(#file) \(#line)")
                        completion(nil)
                        return
                    }
                    guard let data = data else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); completion(nil); return}
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String:AnyObject] {
                            completion(json)
                            print("🎾 resulting json",json)
                        }
                    }catch let er{
                        print("❌ There was an error in \(#function) \(er) : \(er.localizedDescription) : \(#file) \(#line)")
                        completion(nil)
                    }
                }.resume()
            }
        }
        
        
        
        static func updateDelivery(delivery: Delivery) {
            DispatchQueue.global(qos: .userInitiated).async {
                guard let url = BackEndUrls.updateDeliveryUrl(delivery: delivery) else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                    
                let params : [String : Any] = getParams(delivery: delivery)
                
                do {
                    let requestBody = try JSONSerialization.data(withJSONObject: params, options: .init())
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    request.httpBody = requestBody
                    request.setValue("application/json", forHTTPHeaderField: "content-type")
                    
                    URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription) : \(#file) \(#line)")
                            return
                        }
                        if let response = response {
                            print("UPDATE RESPONSE: ", response, data)
                        }
                        
                    }.resume()
                    
                    
                }catch let er{
                    
                    print("❌ There was an error in \(#function) \(er) : \(er.localizedDescription) : \(#file) \(#line)")
                }
            }
        }
        
        ///Deletes a delivery from the backend
        static func deleteDelivery(delivery: Delivery) {
            DispatchQueue.global(qos: .userInitiated).async {
                guard let url = BackEndUrls.deleteDeliveryUrl(delivery: delivery) else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                
                var request = URLRequest(url: url)
                request.httpMethod = "DELETE"
                
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription) : \(#file) \(#line)")
                        return
                    }
                    if let response = response {
                        print("🏐 POST RESPONSE: ", response)
                    }
                }.resume()
            }
        }
        /// Sends a post Request to the AWS BackEnd for all the deliveries in the array
        static func postDelivery(deliveries: [Delivery]) {
            
            for delivery in deliveries {
                
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    let url = BackEndUrls.postDeliveryUrl
                    let params : [String : Any] = getParams(delivery: delivery)
                    
                    guard let deliveryData = try? JSONSerialization.data(withJSONObject: params, options: .init()) else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.httpBody = deliveryData
                    request.setValue("application/json", forHTTPHeaderField: "content-type")
                    
                    URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription) : \(#file) \(#line)")
                            return
                        }
                        if let response = response {
                            print("🏐 POST RESPONSE: ", response)
                        }
                    }.resume()
                    
                }
            }
        }
    }
}
