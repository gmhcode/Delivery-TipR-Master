//
//  ConfirmNewViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/2/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

class ConfirmAccountViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var confirmationTextField: MDCTextField!
    
    var confirmationController: MDCTextInputControllerOutlined?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextControllers()
        setDelegates()
        
        guard let email = UserController.fetchUser()?.email else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        emailLabel.text = email
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    
    
    
    func setTextControllers() {
        confirmationController = MDCTextInputControllerOutlined(textInput: confirmationTextField)
    }
    func setDelegates(){
        confirmationTextField.delegate = self
    }
    
    @IBAction func confirmCodeTapped(_ sender: Any) {
        guard let confirmationCode = confirmationTextField.text else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        Authorization.global.confirm(confirmationCode: confirmationCode, vc: self) { (confirmationState) in
            
            if confirmationState != nil {
                DispatchQueue.main.async {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    
                }
            }
            
        }
    }
    
    @IBAction func sendNewCodeTapped(_ sender: Any) {
        Authorization.global.resendConfirmationCode()
    }
    
    
    @IBAction func dismissKeyboardTapped(_ sender: Any) {
        if confirmationTextField.isFirstResponder == true {
            confirmationTextField.resignFirstResponder()
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension ConfirmAccountViewController : UITextFieldDelegate {
    
}
