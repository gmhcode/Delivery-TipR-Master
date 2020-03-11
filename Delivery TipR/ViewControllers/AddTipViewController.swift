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
    
    
    
    ///Shows the total amount of deliveries sent to this location
    @IBOutlet weak var delivNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var location : Location!
    var delivery : Delivery!
    lazy var finishedDeliveries = DeliveryController.getFinishedDeliveries(for: location)
    lazy var unfinishedDeliveries = DeliveryController.getUnfinishedDeliveries(for: location)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tipTextField.delegate = self
        setViews()
    }
    
    @IBAction func dismissKeyboardTappedContainer(_ sender: Any) {
        dismissKeyboard()
    }
    
    @IBAction func confirmAmountButtonTapped(_ sender: Any) {
        
        let amount = Float(tipTextField.text ?? "0.00") ?? 0.00
        let _ = DeliveryController.finishDelivery(delivery: delivery, tipAmount: amount)
        LocationController.setAverageTipFor(location: location)
        //Remove the annotation for this delivery
        checkLocationForUnfinished(location)
        MapViewController.MapVC.tableView.reloadData()
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissSelfButtonTapped(_ sender: Any) {
        if tipTextField.isFirstResponder == true {
            tipTextField.resignFirstResponder()
        }
        else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    @IBAction func dismissKeyboardTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    
    func dismissKeyboard(){
        if tipTextField.isFirstResponder == true {
            tipTextField.resignFirstResponder()
        }
    }
    /// Checks to see if there are any more unfinished deliveries for the current location. If there aren't, remove the annotation for that location
    func checkLocationForUnfinished(_ location: Location) {
            
        let finishedDeliveries = DeliveryController.getUnfinishedDeliveries(for: location)
        
        if finishedDeliveries.isEmpty {
            let annotation = MapViewController.MapVC.mapView.annotations.filter({$0.subtitle == location.subAddress})
            MapViewController.MapVC.mapView.removeAnnotations(annotation)
        }
    }
    
    func setViews(){
        averageTipLabel.text = finishedDeliveries.count > 0 ? "\(location.averageTip.doubleToMoneyString())" : "N/A"
        
        
        delivNumberLabel.text = "\(finishedDeliveries.count)"
        
        addressLabel.text = location.address
        okButton.setTitle("Confirm Amount", for: .normal)
        
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
extension AddTipViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Find out what the text field will be after adding the current edit
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if Double(text) != nil || text == "" {
            // Text field converted to an Int
            okButton.isEnabled = true
            okButton.setTitle("Confirm Amount", for: .normal)
            
        } else {
            // Text field is not an Int
            okButton.isEnabled = false
            //            okButton.setTitle("Invalid Amount", for: .normal)
            okButton.titleLabel?.text = "Invalid Amount"
        }
        // Return true so the text field will be changed
        return true
    }
}
