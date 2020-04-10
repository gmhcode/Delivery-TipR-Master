//
//  AdvancedViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/13/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit


class AdvancedViewController: UIViewController {
    
    @IBOutlet weak var tripInfoView: AdvancedDisplayView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var viewTitle: UILabel!
    
    var deliveryfetch : (() -> [Delivery]?)?
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    override func viewDidLayoutSubviews() {
        
        setupViews()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
        #warning("uncomment for test")
        TestFuncs.setUpTestDeliveries().sorted(by: {$0.date > $1.date})
        

        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1794748008, green: 0.1844923198, blue: 0.1886624992, alpha: 1)], for: .normal)
       
        segmentChanged(self)
        
    }
    func setupTripInfoView() {

        
        
    }
    
    
    @IBAction func detailsTapped(_ sender: Any) {
        performSegue(withIdentifier: "displaySegue", sender: nil)
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
            //Today
        case 0 :
            viewTitle.text = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
            
            deliveryfetch = DeliveryController.fetchTodaysDeliveries
            
            guard let deliveryFetch = deliveryfetch else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            
             let advancedDisplayViewModel = AdvancedDisplayViewModel(deliveries: deliveryFetch() ?? [])
            
            
            tripInfoView.advancedDisplayViewModel = advancedDisplayViewModel
            break
            //This Week
        case 1:
            viewTitle.text = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
            
            deliveryfetch = DeliveryController.fetchThisWeeksDeliveries
            
            guard let deliveryFetch = deliveryfetch else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            
             let advancedDisplayViewModel = AdvancedDisplayViewModel(deliveries: deliveryFetch() ?? [])
            
            
            tripInfoView.advancedDisplayViewModel = advancedDisplayViewModel
            break
            //This Month
        case 2:
            
            viewTitle.text = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
            
            guard let deliveryFetch = deliveryfetch else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            
             let advancedDisplayViewModel = AdvancedDisplayViewModel(deliveries: deliveryFetch() ?? [])
            
            
            tripInfoView.advancedDisplayViewModel = advancedDisplayViewModel
            break
            //This Year
        case 3:
            viewTitle.text = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
            
            
            deliveryfetch = DeliveryController.fetchThisYearsDeliveries
            
            guard let deliveryFetch = deliveryfetch else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            
             let advancedDisplayViewModel = AdvancedDisplayViewModel(deliveries: deliveryFetch() ?? [])
            
            
            tripInfoView.advancedDisplayViewModel = advancedDisplayViewModel
            break
        case 4:
            viewTitle.text = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
            deliveryfetch = DeliveryController.fetchAllDeliveries
            
            guard let deliveryFetch = deliveryfetch else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            
             let advancedDisplayViewModel = AdvancedDisplayViewModel(deliveries: deliveryFetch() ?? [])
            
            
            tripInfoView.advancedDisplayViewModel = advancedDisplayViewModel
            break
        default :
            break
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displaySegue"{
            guard  let historyVC = segue.destination as? HistoryTableViewController,
                let deliveryFetch = deliveryfetch else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
//            historyVC.deliveries = deliveries
            historyVC.deliveryfetch = deliveryFetch
            historyVC.navigationTitle = viewTitle.text ?? ""
           
        }
    }
    
    
}



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
