//
//  EditAddressViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/19/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class EditAddressViewController: UIViewController {
    
    var delivery : Delivery?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var apartmentText = ""
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var coordinate : CLLocationCoordinate2D?
    var address = ""
    var subAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchCompleter.delegate = self
    }
    

    

}
extension EditAddressViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    // MARK: - CellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchResult = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        #warning("DeleteTestFunc")
                TestFuncs.populateDeliveryTests(indexPath: indexPath, searchResults: searchResults)
        
        return cell
    }
    
    
    // MARK: - SelectRow
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = #colorLiteral(red: 0.939237535, green: 0.939237535, blue: 0.939237535, alpha: 1)
        cell?.detailTextLabel?.textColor = #colorLiteral(red: 0.947724402, green: 0.947724402, blue: 0.947724402, alpha: 1)
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        
        let search = MKLocalSearch(request: searchRequest)
        // the response holds the mapItems which holds the coordinates
        search.start { (response, error) in
            
            self.coordinate = response?.mapItems[0].placemark.coordinate
            self.address = self.searchResults[indexPath.row].title
            self.subAddress = self.searchResults[indexPath.row].subtitle
            
            
            
            print(String(describing: self.coordinate))
        }
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        cell?.detailTextLabel?.textColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
    }
}
extension EditAddressViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ///tells the searchCompleter to look for new text
        searchCompleter.queryFragment = searchText
        
    }
}
// MARK: - Alerts
extension EditAddressViewController {
    
    func selectedAddressAlert() {
        
//        let alertController = UIAlertController(title: "", message: <#T##String?#>, preferredStyle: <#T##UIAlertController.Style#>)
        
    }
    func confirmAddressAlert() {
        guard let delivery = delivery else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

        let alertController = UIAlertController(title: "Is This Right?", message: "Are you sure you want to add \(address) to your trip", preferredStyle: .alert)
        
        
        let okButton = UIAlertAction(title: "Yes", style: .default) { (yes) in
            
            guard let coordinate = self.coordinate else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            

            #warning("TAKE A CLOSER LOOK AT THIS, MIGHT CAUSE BUGS")
            LocationController.createLocation(address: self.address, latitude: coordinate.latitude, longitude: coordinate.longitude, subAddress: self.subAddress, phoneNumber: delivery.locationId)
            
            DeliveryController.editDelivery(delivery: delivery, phoneNumber: delivery.locationId, tipAmount: delivery.tipAmonut, address: self.address)
            self.dismiss(animated: true, completion: nil)
            
        }
        let cancelButton = UIAlertAction(title: "No", style: .cancel) { (cancel) in
            
        }
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
}
extension EditAddressViewController : MKLocalSearchCompleterDelegate {
    ///when the results changed (because the text changed) this will be called
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    
}
