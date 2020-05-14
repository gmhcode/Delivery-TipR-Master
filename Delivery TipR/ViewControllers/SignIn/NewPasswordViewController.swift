//
//  NewPasswordViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/5/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields
import AWSMobileClient
class NewPasswordViewController: UIViewController {
    
    @IBOutlet weak var confirmationCodeTextField: MDCTextField!
    @IBOutlet weak var newPasswordTextField: MDCTextField!
    @IBOutlet weak var retypePasswordTextField: MDCTextField!
    
    var email : String?
    
    var confirmationController: MDCTextInputControllerOutlined?
    var newPasswordController: MDCTextInputControllerOutlined?
    var retypePasswordController: MDCTextInputControllerOutlined?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        configureTextFields()
        // Do any additional setup after loading the view.
    }
    
    func setDelegates(){
        confirmationCodeTextField.delegate = self
        newPasswordTextField.delegate = self
        retypePasswordTextField.delegate = self
    }
    func configureTextFields() {
        
        confirmationCodeTextField.tag = 0
        newPasswordTextField.tag = 1
        retypePasswordTextField.tag = 2
        
        confirmationController = MDCTextInputControllerOutlined(textInput: confirmationCodeTextField)
        
        newPasswordController = MDCTextInputControllerOutlined(textInput: newPasswordTextField)
        
        retypePasswordController = MDCTextInputControllerOutlined(textInput: retypePasswordTextField)
    }
    
    
    @IBAction func updatePasswordTapped(_ sender: Any) {
        guard let email = self.email, let password = self.newPasswordTextField.text else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        
        
        Authorization.global.newPassword(email: email, newPassword: newPasswordTextField.text, reTypePassword: retypePasswordTextField.text, confirmationCode: confirmationCodeTextField.text, vc: self) { [weak self] (confirmationState) in
            
            AWSMobileClient.default().getUserAttributes { (dictionary, error) in
                guard let dictionary = dictionary,let uuid = dictionary["custom:uuid"] else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                print(dictionary)
                
                if confirmationState != nil {
                    BackEndController.signInFetch(email: email, uuid: uuid, username: email, password: password)
                    DispatchQueue.main.async {
                        self?.navigationController?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}


extension NewPasswordViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
}
