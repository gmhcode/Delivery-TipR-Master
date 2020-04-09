//
//  LocationTipViewModel.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/8/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation

struct LocationTipViewModel {
    let tip : String
    let address : String
    
    init(location:Location) {
        self.tip = location.averageTip.doubleToMoneyString()
        self.address = location.address
    }
    
}
