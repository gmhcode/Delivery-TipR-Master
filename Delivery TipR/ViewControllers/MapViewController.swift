//
//  ViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/1/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LocationController.createLocation()
        
        let location = LocationController.getALLLocations()[0]
        LocationController.getLocation(with: location.address)
        DeliveryController.createDelivery(for: location)
        DeliveryController.getALLDeliveries()
        DeliveryController.deleteDeliveries()
        LocationController.deleteDatabase()
    }


}

