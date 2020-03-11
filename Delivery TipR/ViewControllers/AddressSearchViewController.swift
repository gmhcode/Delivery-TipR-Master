//
//  AddressSearchViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/4/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
import MapKit
import Contacts

protocol AddressSearchViewControllerDelegate: class {
    func addPin(coord: CLLocationCoordinate2D, address: String, apt: String?, subAddress: String)
}


class AddressSearchViewController: UIViewController {
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var newTripButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var apartmentText = ""
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var coordinate : CLLocationCoordinate2D?
    var address = ""
    var subAddress = ""
    
    
    weak var delegate : AddressSearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchCompleter.delegate = self
        
        
    }
    override func viewDidLayoutSubviews() {
        buttonSetUp()
    }
    
    // MARK: - Go Button Tapped
    @IBAction func goButtonTapped(_ sender: Any) {
        goButton.pulsate()
    }
    // MARK: - NewTrip Tapped
    @IBAction func newTripButtonTapped(_ sender: Any) {
        newTripButton.pulsate()
        let _ = TripController.createNewTrip()
        MapViewController.MapVC.tableView.reloadData()
        MapViewController.MapVC.mapView.removeAnnotations(MapViewController.MapVC.mapView.annotations)
        
    }
    // MARK: - Dismiss Keyboard
    @IBAction func dismissKeyboard(_ sender: Any) {
        dismissKeyboard()
        
        
    }
    func dismissKeyboard() {
        if searchBar.isFirstResponder == true {
            searchBar.resignFirstResponder()
        }
    }
    
    // MARK: - Confirm Delivery Alert
    func confirmDelivery() {
        let alertController = UIAlertController(title: "Is This Right?", message: "Are you sure you want to add \(address) to your trip", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Yes", style: .default) { (yes) in
            // Add pin,
            guard let coordinate = self.coordinate else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            // MARK: - AddPin
            self.delegate?.addPin(coord: coordinate, address: self.address, apt: self.apartmentText, subAddress: self.subAddress)
        }
        let cancelButton = UIAlertAction(title: "No", style: .cancel) { (cancel) in
            
        }
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - TableView Delegate
extension AddressSearchViewController : UITableViewDelegate, UITableViewDataSource {
    // MARK: - Rows In section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    // MARK: - CellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchResult = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        
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
            
            self.confirmDelivery()
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

// MARK: - SearchCompleterDelegate
extension AddressSearchViewController: MKLocalSearchCompleterDelegate{
    ///when the results changed (because the text changed) this will be called
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
}
// MARK: - Search Bar Delegate
extension AddressSearchViewController: UISearchBarDelegate, UITextFieldDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ///tells the searchCompleter to look for new text
        searchCompleter.queryFragment = searchText
        
    }
        
   
}













// MARK: - View Setuo
extension AddressSearchViewController {
    func buttonSetUp(){
        
        searchBar.searchTextField.textColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        searchBar.layer.cornerRadius = 10
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = #colorLiteral(red: 0.1456923485, green: 0.1448334754, blue: 0.1463571787, alpha: 1)
        searchBar.layer.masksToBounds = true
        
        
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = #colorLiteral(red: 0.1456923485, green: 0.1448334754, blue: 0.1463571787, alpha: 1)
        tableView.layer.masksToBounds = true
        
        
        goButton.layer.borderWidth = 1
        goButton.layer.borderColor = #colorLiteral(red: 0.01656158641, green: 0.01656158641, blue: 0.01656158641, alpha: 1)
        goButton.layer.cornerRadius = //10
        goButton.frame.width / 2

        
        goButton.layer.shadowPath =
            UIBezierPath(roundedRect: self.goButton.bounds,
                         cornerRadius: self.goButton.layer.cornerRadius).cgPath
        goButton.layer.shadowColor = #colorLiteral(red: 0, green: 0.6931768656, blue: 0, alpha: 1)
        goButton.layer.shadowOpacity = 0.5
        goButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        goButton.layer.shadowRadius = 5
        goButton.layer.masksToBounds = false
        
    
        newTripButton.layer.borderWidth = 1
        newTripButton.layer.borderColor = #colorLiteral(red: 0.01939361915, green: 0.002321439795, blue: 0, alpha: 1)
        newTripButton.layer.cornerRadius = //10
        newTripButton.frame.width / 2
        
        newTripButton.layer.shadowPath =
            UIBezierPath(roundedRect: self.newTripButton.bounds,
                         cornerRadius: self.newTripButton.layer.cornerRadius).cgPath
        newTripButton.layer.shadowColor = #colorLiteral(red: 0.7445355058, green: 0.05634019524, blue: 0, alpha: 1)
        newTripButton.layer.shadowOpacity = 0.5
        newTripButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        newTripButton.layer.shadowRadius = 5
        newTripButton.layer.masksToBounds = false
        
    }
}
