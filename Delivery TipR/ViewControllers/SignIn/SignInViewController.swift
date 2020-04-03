//
//  BlahViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/2/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
import MaterialComponents

class SignInViewController: UIViewController {

    @IBOutlet weak var helloTextField: MDCTextField!
    @IBOutlet weak var blahTextField: MDCTextField!
    
    var nameController: MDCTextInputControllerOutlined?
    var passwordController : MDCTextInputControllerOutlined?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameController = MDCTextInputControllerOutlined(textInput: helloTextField)
        passwordController = MDCTextInputControllerOutlined(textInput: blahTextField)
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
