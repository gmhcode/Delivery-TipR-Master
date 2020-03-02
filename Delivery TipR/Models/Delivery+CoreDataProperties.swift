//
//  Delivery+CoreDataProperties.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/1/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//
//

import Foundation
import CoreData


extension Delivery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Delivery> {
        return NSFetchRequest<Delivery>(entityName: "Delivery")
    }

    @NSManaged public var tipAmonut: Float
    @NSManaged public var address: String
    @NSManaged public var locationId: String
    @NSManaged public var id: String

}
