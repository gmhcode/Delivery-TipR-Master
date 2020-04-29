//
//  HistoryTableViewCell.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/19/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var delivery : Delivery? {
        didSet{
            setupViews()
        }
    }
    
    
    func setupViews() {
        guard let delivery = delivery else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.text = delivery.address
        tipLabel.adjustsFontSizeToFitWidth = true
        tipLabel.text = delivery.tipAmount.toCurrencyString()
        
    }
    
    
}
