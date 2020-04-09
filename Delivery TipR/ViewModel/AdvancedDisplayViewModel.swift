//
//  AdvancedDisplayViewModel.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/9/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation

struct AdvancedDisplayViewModel {
    let tripCount : String
    let deliveryCount : String
    let avgDeliveryTip : String
    let avgTripTip: String
    let totalTips : String
    
    init(deliveries: [Delivery]) {
        
        
         let trips = Set(deliveries.map({$0.tripId})).compactMap({TripController.getTrip(from: $0)[0]})
        
         let tripTips = (trips.map({getAverageTip(deliveries:DeliveryController.getTripDeliveries(trip: $0))}).reduce(0,+) / Double(trips.count)).doubleToMoneyString()
        
        let totalTips = Double(deliveries.map({$0.tipAmonut}).reduce(0,+)).doubleToMoneyString()
        
        self.tripCount = String(trips.count)
        self.deliveryCount = String(deliveries.count)
        self.avgDeliveryTip = getAverageTipString(deliveries: deliveries)
        self.avgTripTip = tripTips
        self.totalTips = totalTips
        
    }
}
