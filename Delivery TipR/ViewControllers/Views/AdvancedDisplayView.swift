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

    
    var deliveries : [Delivery]? {
        didSet {
            setViews()
        }
    }
    
    
    func setViews() {
        guard let deliveries = deliveries else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

        deliveryCountLabel.text = String(deliveries.count)
        //get the average of all the deliveries
        avgDeliveryTipLabel.text = Double(deliveries.map({$0.tipAmonut}).reduce(0,+) / Float(deliveries.count)).doubleToMoneyString()
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
