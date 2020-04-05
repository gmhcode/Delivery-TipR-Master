//
//  navViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/5/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class navViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func tapped(_ sender: Any) {
//             self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.dismiss(animated: true, completion: nil)
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
