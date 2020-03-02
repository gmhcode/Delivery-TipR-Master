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
        LocationController.shared.createLocation()
        LocationController.shared.getALLLocations()
        let location = LocationController.shared.locations[0]
        LocationController.shared.getLocation(with: location.address)
        LocationController.shared.deleteDatabase()
    }


}

