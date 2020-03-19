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
    
    var deliveries : [Delivery]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    override func viewDidLayoutSubviews() {
        
        setupViews()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if deliveries == nil {
            #warning("FOR TESTING ONLY")
            deliveries = TestFuncs.setUpTestDeliveries().sorted(by: {$0.date > $1.date})
        } else {
            deliveries = DeliveryController.getALLDeliveries()
        }
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
            guard let deliveries = DeliveryController.fetchTodaysDeliveries() else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            let todaysDeliveries = deliveries.filter({Date(timeIntervalSince1970: $0.date).isInToday})
            
            tripInfoView.deliveries = todaysDeliveries
            break
            //This Week
        case 1:
            viewTitle.text = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
            
            guard let deliveries = DeliveryController.fetchThisWeeksDeliveries() else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            let thisWeeksDeliveries = deliveries.filter({Date(timeIntervalSince1970: $0.date).isInThisWeek})
            
            tripInfoView.deliveries = thisWeeksDeliveries
            break
            //This Month
        case 2:
            
            viewTitle.text = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
            guard let deliveries = DeliveryController.fetchThisMonthsDeliveries() else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            let thisWeeksDeliveries = deliveries.filter({Date(timeIntervalSince1970: $0.date).isInThisMonth})
            
            tripInfoView.deliveries = thisWeeksDeliveries
            break
            //This Year
        case 3:
            viewTitle.text = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
            guard let deliveries = DeliveryController.fetchThisYearsDeliveries() else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            let thisWeeksDeliveries = deliveries.filter({Date(timeIntervalSince1970: $0.date).isInThisYear})
            
            tripInfoView.deliveries = thisWeeksDeliveries
            break
        default :
            break
        }
    }
    func advancedDisplaySetup() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displaySegue"{
            guard  let historyVC = segue.destination as? HistoryTableViewController,
                let deliveries = tripInfoView.deliveries else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            historyVC.deliveries = deliveries
            historyVC.navigationTitle = viewTitle.text ?? ""
           
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
