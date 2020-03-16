//
//  Trip+CoreDataProperties.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/5/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var id: String
    @NSManaged public var date: Double
    @NSManaged public var isCurrent: Int16
    @NSManaged public var thing : Double
}
