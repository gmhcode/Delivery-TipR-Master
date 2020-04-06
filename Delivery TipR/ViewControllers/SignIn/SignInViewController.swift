//
//  BlahViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/2/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields
import AWSMobileClient

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: MDCTextField!
    
    @IBOutlet weak var passwordTextField: MDCTextField!
    
    var emailController: MDCTextInputControllerOutlined?
    var passwordController : MDCTextInputControllerOutlined?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextControllers()
        
    }
    
    func configureTextControllers(){
        emailController = MDCTextInputControllerOutlined(textInput: emailTextField)
        passwordController = MDCTextInputControllerOutlined(textInput: passwordTextField)
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

        
        Authorization.global.signIn(email: emailTextField.text, password: passwordTextField.text, vc: self) { [weak self] (state) in
            if state != nil {
                AWSMobileClient.default().getUserAttributes { (dictionary, error) in
                
                    guard let dictionary = dictionary,let uuid = dictionary["custom:uuid"] else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                    print(dictionary)
                    let user = UserController.createUser(email: email, uuid: uuid, username: email, password: password)
                   
                    
                    DispatchQueue.main.async {
                        self?.navigationController?.dismiss(animated: true, completion: nil)
                        
                    }
                }
                
            }
        }
    }
}
