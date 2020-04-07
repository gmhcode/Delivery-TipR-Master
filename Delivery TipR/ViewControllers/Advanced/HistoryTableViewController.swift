//
//  HistoryTableViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/18/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    var deliveries : [Delivery] = []
    var deliveryfetch : (() -> [Delivery]?)?
    
    var navigationTitle : String = ""
    let timeFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = navigationTitle
        setTimeFormatter()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    func setTimeFormatter() {
        switch navigationTitle {
        case "Today":
            timeFormatter.timeStyle = .short
            break
        case "Week":
            timeFormatter.dateFormat = "MMM d"
            break
        case "Month":
            timeFormatter.dateFormat = "MMM d"
            break
        case "Year":
            timeFormatter.dateFormat = "MMM d yyyy"
            break
        case "Total":
            timeFormatter.dateFormat = "MMM d yyyy"
            break
        default:
            break
        }
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return deliveries.count
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let deliveryFetch = deliveryfetch else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return deliveries.count}
        
        deliveries = deliveryFetch() ?? []
        print(deliveries.count)
        return deliveries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "displayDeliveryCell", for: indexPath) as? HistoryTableViewCell  else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return UITableViewCell()}
        cell.textLabel?.textColor = #colorLiteral(red: 0.1794748008, green: 0.1844923198, blue: 0.1886624992, alpha: 1)
        cell.detailTextLabel?.textColor = #colorLiteral(red: 0.1794748008, green: 0.1844923198, blue: 0.1886624992, alpha: 1)
        cell.selectedBackgroundView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3062865497)
        
        
        let dateString = timeFormatter.string(from: Date(timeIntervalSince1970: deliveries[indexPath.row].date))
        
        cell.delivery = deliveries[indexPath.row]
        
        cell.timeLabel.text = dateString
        cell.timeLabel.adjustsFontSizeToFitWidth = true
        
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editDeliverySegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
            let destination = segue.destination as? EditDeliveryTableViewController else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        let delivery = deliveries[indexPath.row]
        destination.delivery = delivery
        destination.historyTVC = self
//        destination.historyTVC = self
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
