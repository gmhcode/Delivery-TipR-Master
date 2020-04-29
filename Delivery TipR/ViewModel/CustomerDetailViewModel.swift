//
//  CustomerDetailViewModel.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/11/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation

struct CustomerDetailViewModel {
    
    let numberOfDeliveries : String
    let averageTip : String
    let addressLabel : String
    let cellViews : [(String,String)]
    let dateFormatter = DateFormatter()
    
    init(location: Location) {
        
        let deliveries = DeliveryController.getFinishedDeliveries(for: location)
        self.numberOfDeliveries = String(deliveries.count)
        self.averageTip = deliveries.count > 0 ? "\(location.averageTip.doubleToMoneyString())" : "N/A"
        self.addressLabel = location.address
        dateFormatter.dateFormat = "MMM d yyyy"
        
        
        var deliveryTuples : [(String,String)] = []
        for delivery in deliveries {
            
            let date = Date(timeIntervalSince1970: delivery.date)
            let dateString = dateFormatter.string(from: date)
            let tip = delivery.tipAmount.toCurrencyString()
            let tuple = (dateString,tip)
            deliveryTuples.append(tuple)
        }
        
        self.cellViews = deliveryTuples
       
        
        
    }
    
    func populateCellViews(deliveries: [Delivery]) -> [(String,String)] {
        
        var deliveryTuples : [(String,String)] = []
        
        for delivery in deliveries {
            
            let date = Date(timeIntervalSince1970: delivery.date)
            let dateString = dateFormatter.string(from: date)
            let tip = delivery.tipAmount.toCurrencyString()
            let tuple = (dateString,tip)
            deliveryTuples.append(tuple)
        }
        
        return deliveryTuples
        
    }
    
}
