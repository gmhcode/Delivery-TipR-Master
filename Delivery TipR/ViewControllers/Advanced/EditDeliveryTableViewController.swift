//
//  EditDeliveryTableViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/19/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class EditDeliveryTableViewController: UITableViewController {

    var delivery : Delivery? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "deliveryEditCell")
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
        
        addPhoneNumberAlert()
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let delivery = delivery else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return UITableViewCell()}
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1,
        reuseIdentifier: "deliveryEditCell")

        
        
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
    

    
    func addPhoneNumberAlert(){
    let alertController = UIAlertController(title: "Phone Number", message: "Please Enter The Phone Number For This Location", preferredStyle: .alert)
    
    
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
            DeliveryController.editDelivery(delivery: self.delivery!, phoneNumber: "HAHAHAHA", tipAmount: 100.00, address: "HAHAHAHAHA")
        }
        
    }
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func checkIfRealPhoneNumber(){
        
        let alertController = UIAlertController(title: "Not Enough Numbers", message: "Phone Number must have 10 Digits", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel) { (_) in
            self.addPhoneNumberAlert()
        }
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
