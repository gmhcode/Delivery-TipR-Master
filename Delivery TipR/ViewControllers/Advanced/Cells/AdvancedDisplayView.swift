//
//  AdvancedDisplayView.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/16/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class AdvancedDisplayView: UIView {
    
    @IBOutlet weak var tripCountView: UILabel!
    @IBOutlet weak var deliveryCountLabel: UILabel!
    @IBOutlet weak var avgDeliveryTipLabel: UILabel!
    @IBOutlet weak var avgTripTipLabel: UILabel!
    @IBOutlet weak var totalTipsLabel: UILabel!
 
    
    
    var advancedDisplayViewModel : AdvancedDisplayViewModel? {
        didSet {
            setViews()
        }
    }
    
    @IBAction func displayViewTapped(_ sender: Any) {
        print("lol")
     }
    
    func setViews() {
        guard let advancedDisplayViewModel = advancedDisplayViewModel else { print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return }
//        // Seperate all the duplicate tripId's with Set, for each tripId, find the matching trip
//        let trips = Set(deliveries.map({$0.tripId})).compactMap({TripController.getTrip(from: $0)[0]})
//
//        let tripTips = (trips.map({getAverageTip(deliveries:DeliveryController.getTripDeliveries(trip: $0))}).reduce(0,+) / Double(trips.count)).doubleToMoneyString()
//
//        let totalTips = Double(deliveries.map({$0.tipAmonut}).reduce(0,+)).doubleToMoneyString()
        
        tripCountView.text = advancedDisplayViewModel.tripCount
        deliveryCountLabel.text = advancedDisplayViewModel.deliveryCount
        //Get the average of all the deliveries
        avgDeliveryTipLabel.text = advancedDisplayViewModel.avgDeliveryTip
        avgTripTipLabel.text = advancedDisplayViewModel.avgTripTip
        totalTipsLabel.text = advancedDisplayViewModel.totalTips
        
    }
}
