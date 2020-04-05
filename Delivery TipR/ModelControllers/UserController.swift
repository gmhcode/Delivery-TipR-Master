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
    static func createUser(email: String, uuid: String, username: String, password: String) -> User {
        
        // If the user already exists with the preferred email, return that user
        if let fetchedUser = fetchUserWith(email: email) {
            return fetchedUser
        }
        ///If Someone enteres the wrong email when signing up, we need to delete the old user
        if let _ = fetchUser() {
            deleteUser()
        }
            
            let persistentManager = PersistenceManager.shared
            let user = User(context: persistentManager.context)
            user.email = email
            user.password = password
            user.username = username
            user.uuid = uuid
            persistentManager.saveContext()
            
            return user
        
        
    }
    
    static func fetchUserWith(email:String) -> User? {
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<User> = User.fetchRequest()
        let predicate = NSPredicate(format: "email CONTAINS[cd] %@", email)
        request.predicate = predicate
        
        do {
            let users = try persistentManager.context.fetch(request)
            if users.count >= 1 {
                print(users, "🥇")
                return users[0]
            } else {
                return nil
            }
           
        } catch  {
            print("array could not be retrieved \(error)")
            return nil
        }
    }
    
    /// Fetches the existsing user, if there is one
    static func fetchUser() -> User? {
        let persistentManager = PersistenceManager.shared
        let request : NSFetchRequest<User> = User.fetchRequest()

        
        do {
            let users = try persistentManager.context.fetch(request)
            if users.count >= 1 {
                print(users, "🥇")
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
}
