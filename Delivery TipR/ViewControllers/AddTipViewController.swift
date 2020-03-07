//
//  AddTipViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/7/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class AddTipViewController: UIViewController {

 @IBOutlet weak var tipTextField: UITextField!
 @IBOutlet weak var averageTipLabel: UILabel!
 @IBOutlet weak var okButton: UIButton!
 @IBOutlet weak var cancelButton: UIButton!
 @IBOutlet weak var undoLastButton: UIButton!
 @IBOutlet weak var containerView: UIView!
 
 
 ///shows the total amount of deliveries sent to this location
 @IBOutlet weak var delivNumberLabel: UILabel!
 @IBOutlet weak var addressLabel: UILabel!
    
    var location : Location!
    
    lazy var finishedDeliveries = DeliveryController.getFinishedDeliveries(for: location)
    lazy var unfinishedDeliveries = DeliveryController.getUnfinishedDeliveries(for: location)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
//        setViews()
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setViews()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setViews(){
        averageTipLabel.text = finishedDeliveries.count > 0 ? "\(location.averageTip.doubleToMoneyString())" : "N/A"

        delivNumberLabel.text = "\(finishedDeliveries.count)"
        
        addressLabel.text = location.address
        
        
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = #colorLiteral(red: 0.05126404017, green: 0.05128084868, blue: 0.05126182735, alpha: 1)
        
        okButton.layer.borderWidth = 1
        okButton.layer.borderColor = #colorLiteral(red: 0.05450475216, green: 0.05450475216, blue: 0.05450475216, alpha: 0.2388751827)
        okButton.layer.shadowPath =
            UIBezierPath(roundedRect: okButton.bounds,
                         cornerRadius: okButton.layer.cornerRadius).cgPath
        okButton.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        okButton.layer.shadowOpacity = 0.5
        okButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        okButton.layer.shadowRadius = 2
        okButton.layer.masksToBounds = false
        
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.241182383)
        cancelButton.layer.shadowPath =
            UIBezierPath(roundedRect: cancelButton.bounds,
                         cornerRadius: cancelButton.layer.cornerRadius).cgPath
        cancelButton.layer.shadowColor = #colorLiteral(red: 0.5911776423, green: 0, blue: 0, alpha: 1)
        cancelButton.layer.shadowOpacity = 0.5
        cancelButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        cancelButton.layer.shadowRadius = 2
        cancelButton.layer.masksToBounds = false
        
        
        undoLastButton.layer.borderWidth = 1
        undoLastButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.241182383)
        undoLastButton.layer.shadowPath =
            UIBezierPath(roundedRect: undoLastButton.bounds,
                         cornerRadius: undoLastButton.layer.cornerRadius).cgPath
        undoLastButton.layer.shadowColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        undoLastButton.layer.shadowOpacity = 0.5
        undoLastButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        undoLastButton.layer.shadowRadius = 2
        undoLastButton.layer.masksToBounds = false
        
        
        
    }

}
