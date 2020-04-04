//
//  ConfirmNewViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/2/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
import MaterialComponents
class ConfirmNewViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var confirmationTextField: MDCTextField!
    
    var confirmationController: MDCTextInputControllerOutlined?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmationController = MDCTextInputControllerOutlined(textInput: confirmationTextField)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmCodeTapped(_ sender: Any) {
    }
    @IBAction func sendNewCodeTapped(_ sender: Any) {
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
