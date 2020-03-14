//
//  AddTipViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/7/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
//import MaterialComponents.MaterialDialogs
//import MaterialComponents.MaterialDialogs_Theming
//import MaterialComponents.MaterialContainerScheme
//import MaterialComponents.MaterialTextFields
import MaterialComponents.MaterialDialogs

class AddTipViewController: UIViewController {
  
    @IBOutlet weak var tipTextField: UITextField!
    
    @IBOutlet weak var averageTipLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var unfinishButton: UIButton!
    @IBOutlet weak var removeDeliveryButton: UIButton!
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
        tipTextField.keyboardType = UIKeyboardType.decimalPad
        setViews()
    }
    
  
    
    @IBAction func confirmAmountButtonTapped(_ sender: Any) {
        
        if let amount = Float(tipTextField.text ?? "0.00") {
            let _ = DeliveryController.finishDelivery(delivery: delivery, tipAmount: amount)
            getReadyForDismiss()
            dismissKeyboard()
            self.dismiss(animated: true, completion: nil)
        } else {
            invalidTipAmountAlert()
        }
        
        
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func undoButtonTapped(_ sender: Any) {
        if delivery.isFinished == 1 {
            let _ = DeliveryController.unFinishDelivery(delivery: delivery)
            getReadyForDismiss()
            MapViewController.MapVC.createAddAnnotation(address: location.address, subAddress: location.subAddress, latitude: location.latitude, longitude: location.longitude)
            cancelButtonTapped(self)
        }else {
            undoTappedInvalid()
        }
    }
    ///If the delivery is finished, this will show an alert explaining they cant remove the delivery till they undo. if the delivery is unfinished, this will delete the delivery and remove annotations
    @IBAction func removeDeliveryButtonTapped(_ sender: Any) {
        if delivery.isFinished == 1 {
            cannotRemoveFinishedAlert()
        }else {
            DeliveryController.deleteDelivery(deliveries: [delivery])
            getReadyForDismiss()
            cancelButtonTapped(self)
        }
    }
    
    
    @IBAction func dismissSelfButtonTapped(_ sender: Any) {
        if tipTextField.isFirstResponder == true {
            tipTextField.resignFirstResponder()
        }
        else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func dismissKeyboardTappedContainer(_ sender: Any) {
        dismissKeyboard()
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
            
        let unfinishedDeliveries = DeliveryController.getUnfinishedDeliveries(for: location)
        
        if unfinishedDeliveries.isEmpty {
            let annotation = MapViewController.MapVC.mapView.annotations.filter({$0.subtitle == location.subAddress})
            MapViewController.MapVC.mapView.removeAnnotations(annotation)
        }
    }
    ///Sets average tip for location, removes finished Annotations, reloads tableView
    func getReadyForDismiss(){
        LocationController.setAverageTipFor(location: location)
        //Remove the annotation for this delivery
        checkLocationForUnfinished(location)
        MapViewController.MapVC.tableView.reloadData()
    }
    
}
// MARK: - Alerts
extension AddTipViewController {
    
    
    func alertThing() {
        
        
        let alertController = MDCAlertController(title: "Invalid Amount", message: "Tip amount must be in this format '0' or '0.00' ")
        let okButton = MDCAlertAction(title: "Ok", emphasis: .high, handler: nil)

        let cancelButton = MDCAlertAction(title: "Cancel", emphasis: .low, handler: nil)

        alertController.addAction(okButton)
        alertController.addAction(cancelButton)

        present(alertController, animated:true, completion:nil)
    }
    
    func invalidTipAmountAlert() {
        
        let alertController = MDCAlertController(title: "Invalid Amount", message: "Tip amount must be in this format '0' or '0.00' ")
        let okButton = MDCAlertAction(title: "Ok", emphasis: .high, handler: nil)

        let cancelButton = MDCAlertAction(title: "Cancel", emphasis: .low, handler: nil)

        alertController.addAction(okButton)
        alertController.addAction(cancelButton)

        present(alertController, animated:true, completion:nil)
        
        
//        let alertController = UIAlertController(title: "Invalid Amount", message: "Tip amount must be in this format '0' or '0.00' ", preferredStyle: .alert)
//        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
//        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(okButton)
//        alertController.addAction(cancelButton)
//        present(alertController, animated: true, completion: nil)
    }
    
    func undoTappedInvalid() {
        
        
        let alertController = MDCAlertController(title: "Nothing to Undo", message: "This delivery's tip must first be confirmed, in order to undo")
        let okButton = MDCAlertAction(title: "Ok", emphasis: .high, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated:true, completion:nil)
        
//        let alertController = UIAlertController(title: "Nothing to Undo", message: "This delivery's tip must first be confirmed, in order to undo", preferredStyle: .alert)
//        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alertController.addAction(okButton)
//        present(alertController, animated: true, completion: nil)
    }
    
    func cannotRemoveFinishedAlert() {
        
        let alertController = MDCAlertController(title: "Unable to remove", message: "This delivery has already been confirmed, if you wish to remove this delivery, first tap the undo button")
        let okButton = MDCAlertAction(title: "Ok", emphasis: .high, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated:true, completion:nil)
        
//        let alertController = UIAlertController(title: "Unable to remove", message: "This delivery has already been confirmed, if you wish to remove this delivery, first tap the undo button", preferredStyle: .alert)
//        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alertController.addAction(okButton)
//        present(alertController, animated: true, completion: nil)
    }
    
}


// MARK: - TextField Delegate
extension AddTipViewController : UITextFieldDelegate, UITextViewDelegate {
    

}
// MARK: - Setup Views
extension AddTipViewController {
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
        cancelButton.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cancelButton.layer.shadowOpacity = 0.5
        cancelButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        cancelButton.layer.shadowRadius = 2
        cancelButton.layer.masksToBounds = false
        
        
        unfinishButton.layer.borderWidth = 1
        unfinishButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.241182383)
        unfinishButton.layer.shadowPath =
            UIBezierPath(roundedRect: unfinishButton.bounds,
                         cornerRadius: unfinishButton.layer.cornerRadius).cgPath
        unfinishButton.layer.shadowColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        unfinishButton.layer.shadowOpacity = 0.5
        unfinishButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        unfinishButton.layer.shadowRadius = 2
        unfinishButton.layer.masksToBounds = false
        
        
        removeDeliveryButton.layer.borderWidth = 1
        removeDeliveryButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.241182383)
        removeDeliveryButton.layer.shadowPath =
            UIBezierPath(roundedRect: removeDeliveryButton.bounds,
                         cornerRadius: removeDeliveryButton.layer.cornerRadius).cgPath
        removeDeliveryButton.layer.shadowColor = #colorLiteral(red: 0.5911776423, green: 0, blue: 0, alpha: 1)
        removeDeliveryButton.layer.shadowOpacity = 0.5
        removeDeliveryButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        removeDeliveryButton.layer.shadowRadius = 2
        removeDeliveryButton.layer.masksToBounds = false
        
    }
    
}
