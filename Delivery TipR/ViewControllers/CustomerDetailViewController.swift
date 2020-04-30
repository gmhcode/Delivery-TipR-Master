//
//  CustomerDetailViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/10/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class CustomerDetailViewController: UIViewController {
    
    var location : Location? {
        didSet {
            guard let location = location else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

            viewModel = CustomerDetailViewModel(location: location)
        }
    }
    var viewModel : CustomerDetailViewModel? 
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var numberOfDeliveriesLabel: UILabel!
    @IBOutlet weak var averageTipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setViews()
     
    }
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    func setViews(){
        guard let viewModel = viewModel else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.text = viewModel.addressLabel
        numberOfDeliveriesLabel.text = viewModel.numberOfDeliveries
        averageTipLabel.text = viewModel.averageTip
        
        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = #colorLiteral(red: 0.1794748008, green: 0.1844923198, blue: 0.1886624992, alpha: 1)

    }
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension CustomerDetailViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return 0}
        return viewModel.cellViews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerDetailViewCell", for: indexPath)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.text = viewModel?.cellViews[indexPath.row].0
        cell.detailTextLabel?.text = viewModel?.cellViews[indexPath.row].1
        
        return cell
    }
    
    
    
    
    
    
    
    
}
