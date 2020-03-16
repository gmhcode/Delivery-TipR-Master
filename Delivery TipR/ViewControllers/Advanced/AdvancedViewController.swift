//
//  AdvancedViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/13/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class AdvancedViewController: UIViewController {
    
    @IBOutlet weak var tripInfoView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var viewTitle: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    override func viewDidLayoutSubviews() {
        
        setupViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0 :
            viewTitle.text = segmentControl.titleForSegment(at: 0)
            segmentControl.sele
            break
        case 1:
            viewTitle.text = segmentControl.titleForSegment(at: 1)
            break
        default :
            break
        }
    }
    
    
    
}



//extension AdvancedViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
//}
extension AdvancedViewController {
    func setupViews(){
        
        navigationItem.title = "Advanced"
        navigationController?.navigationBar.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.layer.borderWidth = 1
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.clipsToBounds = true

//        tableView.layer.cornerRadius = 10
//        tableView.layer.borderWidth = 1
//        tableView.layer.borderColor = #colorLiteral(red: 0.1456923485, green: 0.1448334754, blue: 0.1463571787, alpha: 1)
//        tableView.layer.masksToBounds = true
        
        tripInfoView.layer.borderWidth = 2
        tripInfoView.layer.borderColor = #colorLiteral(red: 0.1456923485, green: 0.1448334754, blue: 0.1463571787, alpha: 1)
        tripInfoView.layer.masksToBounds = true
        
        
        
    }
}
