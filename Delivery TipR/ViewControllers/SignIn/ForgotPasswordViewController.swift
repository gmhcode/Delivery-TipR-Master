//
//  ForgotPasswordViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/4/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? NewPasswordViewController else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        destination.email = emailTextField.text
 
    }
    

}
