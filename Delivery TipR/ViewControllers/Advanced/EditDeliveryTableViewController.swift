//
//  EditDeliveryTableViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/19/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class EditDeliveryTableViewController: UITableViewController {
    
    var delivery : Delivery?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "deliveryEditCell")
        view.backgroundColor = #colorLiteral(red: 0.9598043561, green: 0.9649370313, blue: 0.9775747657, alpha: 1)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "changeAddressSegue", sender: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let delivery = delivery else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return UITableViewCell()}
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1,
                                   reuseIdentifier: "deliveryEditCell")
        cell.textLabel?.textColor = #colorLiteral(red: 0.1794748008, green: 0.1844923198, blue: 0.1886624992, alpha: 1)
        cell.detailTextLabel?.textColor = #colorLiteral(red: 0.1794748008, green: 0.1844923198, blue: 0.1886624992, alpha: 1)
        cell.backgroundColor = #colorLiteral(red: 0.9598043561, green: 0.9649370313, blue: 0.9775747657, alpha: 1)
        
        switch indexPath.section {
        //Tip
        case 0:
            cell.textLabel?.text = delivery.tipAmonut.toCurrencyString()
            break
        //Address
        case 1:
            cell.textLabel?.text = delivery.address
            break
        //CustomerPhone
        case 2:
            cell.textLabel?.text = delivery.locationId
            break
        default:
            break
        }
        cell.detailTextLabel?.text = "Edit"
        return cell
    }
}


// MARK: - Alerts
extension EditDeliveryTableViewController {
    
    func editTipAlert(){
        guard let delivery = delivery else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        let alertController = UIAlertController(title: "Enter Tip", message: "Please Enter The Tip For This Delivery", preferredStyle: .alert)
        
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Tip Amount"
            textField.keyboardType = .decimalPad
            textField.textAlignment = .right
        }
        
        let okButton = UIAlertAction(title: "Confirm", style: .default) { (yes) in
            guard let textField = alertController.textFields?.first else {return}
            
            if let tip = Float(textField.text ?? "0.00") {
                let _ = DeliveryController.finishDelivery(delivery: delivery, tipAmount: tip)
                DeliveryController.editDelivery(delivery: delivery, phoneNumber: delivery.locationId, tipAmount: tip, address: delivery.address)
            } else {
                self.invalidTipAmountAlert()
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func invalidTipAmountAlert() {
        
        
        let alertController = UIAlertController(title: "Invalid Amount", message: "Tip amount must be in this format '0' or '0.00' ", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func editPhoneNumberAlert(){
        guard let delivery = delivery else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        let alertController = UIAlertController(title: "Phone Number", message: "Please Enter The Phone Number For This Delivery", preferredStyle: .alert)
        
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Phone Number"
            textField.delegate = self
            textField.keyboardType = .phonePad
        }
        
        let okButton = UIAlertAction(title: "Confirm", style: .default) { (yes) in
            guard let textField = alertController.textFields?.first else {return}
            if textField.text?.count != 14 {
                self.checkIfRealPhoneNumber()}
            else {
                guard let text = textField.text?.filter({Int(String($0)) != nil}) else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                DeliveryController.editDelivery(delivery: delivery, phoneNumber: text, tipAmount: delivery.tipAmonut, address: delivery.address)
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        alertController.addAction(okButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func checkIfRealPhoneNumber(){
        
        let alertController = UIAlertController(title: "Not Enough Numbers", message: "Phone Number must have 10 Digits", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel) { (_) in
            self.editPhoneNumberAlert()
        }
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
}


extension EditDeliveryTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText:String = textField.text else {return true}
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil { return false }
        let newCount:Int = currentText.count + string.count - range.length
        let addingCharacter:Bool = range.length <= 0
        
        if(newCount == 1){
            textField.text = addingCharacter ? currentText + "(\(string)" : String(currentText.dropLast(2))
            return false
        }else if(newCount == 5){
            textField.text = addingCharacter ? currentText + ") \(string)" : String(currentText.dropLast(2))
            return false
        }else if(newCount == 10){
            textField.text = addingCharacter ? currentText + "-\(string)" : String(currentText.dropLast(2))
            return false
        }
        
        if(newCount > 14){
            return false
        }
        
        return true
    }
}
