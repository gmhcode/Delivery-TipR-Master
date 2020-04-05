//
//  UserController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/5/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation
import CoreData

class UserController {
    
    
    /// Checks to see if a user already exists, if not, creates one
    static func createUser(email: String, uuid: String, username: String, password: String) -> User{
        
        
        if let fetchedUser = fetchUser(){
            return fetchedUser
        } else {
            
            let persistentManager = PersistenceManager.shared
            let user = User(context: persistentManager.context)
            user.email = email
            user.password = password
            user.username = username
            user.uuid = uuid
            persistentManager.saveContext()
            
            return user
        }
        
    }
    
    /// Fetches the existsing user, if there is one
    static func fetchUser() -> User? {
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<User> = User.fetchRequest()

        
        do {
            let users = try persistentManager.context.fetch(request)
            if users.count >= 1 {
                 return users[0]
            } else {
                return nil
            }
           
        } catch  {
            print("array could not be retrieved \(error)")
            return nil
        }
    }
    
    ///Delete
    static func deleteUser() {
        let persistentManager = PersistenceManager.shared
        if let user = fetchUser() {
            persistentManager.delete(user)
        }
        persistentManager.saveContext()
    }
    

    
    
    //    @discardableResult static func createLocation(address: String, latitude: Double, longitude: Double, subAddress: String, phoneNumber: String) -> Location {
//
//           let persistentManager = PersistenceManager.shared
//
//           let existingLocation = getExistingLocation(phoneNumber: phoneNumber)
//           if existingLocation.isEmpty == false {
//               let location = existingLocation[0]
//               if location.address != address {
//                   location.address = address
//                   location.subAddress = subAddress
//                   location.latitude = latitude
//                   location.longitude = longitude
//                   location.phoneNumber = phoneNumber
//                   location.id = phoneNumber
//                   persistentManager.saveContext()
//               }
//               return existingLocation[0]
//           }
//
//
//           let location = Location(context: persistentManager.context)
//           location.address = address
//           location.averageTip = 0
//           location.confirmed = 0
//           location.id = phoneNumber
//           location.phoneNumber = phoneNumber
//           location.latitude = latitude
//           location.longitude = longitude
//           location.subAddress = subAddress
//           persistentManager.saveContext()
//           return location
//       }
}
