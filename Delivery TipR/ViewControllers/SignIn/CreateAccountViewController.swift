//
//  CreateAccountViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/2/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
import MaterialComponents

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
    }
    
    func setTextControllers(){
        emailController = MDCTextInputControllerOutlined(textInput: emailTextField)
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
