//
//  User+CoreDataProperties.swift
//  
//
//  Created by Greg Hughes on 4/5/20.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String
    @NSManaged public var uuid: String
    @NSManaged public var username: String
    @NSManaged public var password: String

}
