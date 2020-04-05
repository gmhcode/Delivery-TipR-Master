//
//  CreateAccountViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/2/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var passwordTextField: MDCTextField!
    @IBOutlet weak var retypePasswordTextField: MDCTextField!
    
    
    var emailController: MDCTextInputControllerOutlined?
    var passwordController: MDCTextInputControllerOutlined?
    var retypeController: MDCTextInputControllerOutlined?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setTextControllers()
    }
    
    func setTextControllers(){
        emailController = MDCTextInputControllerOutlined(textInput: emailTextField)
        
        passwordController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        
        retypeController = MDCTextInputControllerOutlined(textInput: retypePasswordTextField)
    }
    
    
    @IBAction func sendConfirmationButtonTapped(_ sender: Any) {
        guard let emailText = emailTextField.text,
            let passwordText = passwordTextField.text,
            let retypePassword = retypePasswordTextField.text,
            let username = emailTextField.text else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
               
               if passwordText != retypePassword {
                // Show passwords do not match alert
                Authorization.global.passwordDontMatchAlert(vc: self)
                return
               }
        
        
        
        Authorization.global.signUp(vc: self, email: emailText, password: passwordText, username: username, uuid: UUID().uuidString) { [weak self] (confirmationState) in
            if confirmationState == Authorization.ConfirmationState.emailWillBeSent {
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "codeSentSegue", sender: nil)
                }
            }
        }
    } 
}
