//
//  Location+CoreDataProperties.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/1/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }
    /// 0 is false and 1 is true, set to 1 when a delivery at the location is completed
    @NSManaged public var confirmed: Int16
    @NSManaged public var averageTip: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var address: String
    /// This value is going to be the address, can't be a unique id or else the future backend won't work
    @NSManaged public var id: String
    @NSManaged public var subAddress: String
}
