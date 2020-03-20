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
import MaterialComponents

protocol AddressSearchViewControllerDelegate: class {
    func addPin(coord: CLLocationCoordinate2D, address: String, apt: String?, subAddress: String, phoneNumber: String)
}


class AddressSearchViewController: UIViewController {
    @IBOutlet weak var goButton:  UIButton!
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
        //        guard let currentTrip = TripController.getCurrentTrip() else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        //
        //        goButton.isHidden = DeliveryController.getUnfinishedTripDeliveries(trip: currentTrip).count == 0
        buttonSetUp()
    }
    
    // MARK: - Go Button Tapped
    @IBAction func goButtonTapped(_ sender: Any) {
        goButton.pulsate()
        mapsAlert()
    }
    
    
    
    // MARK: - NewTrip Tapped
    @IBAction func newTripButtonTapped(_ sender: Any) {
        guard let currentTrip = TripController.getCurrentTrip() else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        newTripButton.pulsate()
        
        if DeliveryController.getUnfinishedTripDeliveries(trip: currentTrip).isEmpty {
            noFinishedDeliveriesAlert(currentTrip: currentTrip)
            
        }
            
        else if DeliveryController.getUnfinishedTripDeliveries(trip: currentTrip).isEmpty {
            let _ = TripController.createNewTrip()
            MapViewController.MapVC.tableView.reloadData()
            MapViewController.MapVC.mapView.removeAnnotations(MapViewController.MapVC.mapView.annotations)
            MapViewController.MapVC.centerViewOnUserLocation()
        } else {
            // If the ok button is tapped in the alert, the newTripButtonTapped will be called again
            newTripAlert(currentTrip: currentTrip)
        }
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
    
    
    ///Opens the maps app to the location
    func openInMaps(){
        //Get the current trip
        guard let trip = TripController.getCurrentTrip() else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        
        //Get the oldest undelivered delivery
        let delivery = DeliveryController.getUnfinishedTripDeliveries(trip: trip).sorted {$0.date < $1.date}
        if !delivery.isEmpty {
            //Get the location from the oldest undelivered delivery
            let location = LocationController.getExistingLocation(address: delivery[0].address)[0]
            
            let place = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), addressDictionary: [CNPostalAddressStreetKey:location.address])
            
            let mapItem = MKMapItem(placemark: place)
            mapItem.name = location.address
            
            let launchOptions = [MKLaunchOptionsDirectionsModeKey:
                MKLaunchOptionsDirectionsModeDriving]
            
            mapItem.openInMaps(launchOptions: launchOptions)
        }else {return}
    }
    
    
    ///Opens the oldest delivery's location in the apple Maps app
    func mapsAlert() {
        
        
        //Get the current trip
        guard let trip = TripController.getCurrentTrip() else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        //Get the oldest undelivered delivery
        let delivery = DeliveryController.getUnfinishedTripDeliveries(trip: trip).sorted {$0.date < $1.date}
        
        
        if delivery.count > 0 {
            let alertController = MDCAlertController(title: "Opening in Maps", message: "The Maps app is about to open and direct you to \(delivery[0].address), switch back to this app when you have reached your destination to enter your tip.")
            let okButton = MDCAlertAction(title: "OK") { (action) in
                self.openInMaps()
            }
            
            let cancelButton = MDCAlertAction(title: "Cancel", emphasis: .low, handler: nil)
            //            alertController.add
            alertController.addAction(okButton)
            alertController.addAction(cancelButton)
            
            present(alertController, animated:true, completion:nil)
        }else {
            let alertController = MDCAlertController(title: "No Deliveries Entered", message: "You must first have a destination to open the directions in Maps")
            let okButton = MDCAlertAction(title: "OK") { (action) in}
            alertController.addAction(okButton)
            
            present(alertController, animated:true, completion:nil)
        }
        
        //        let alertController = UIAlertController(title: "Opening in Maps", message: "The Maps app is about to open and direct you to \(delivery[0].address), switch back to this app when you have reached your destination to enter your tip.", preferredStyle: .alert)
        //
        //        let okButton = UIAlertAction(title: "Yes", style: .default) { (tapped) in
        //            self.openInMaps()
        //        }
        //        let cancelButton = UIAlertAction(title: "No", style: .cancel, handler: nil)
        //
        //        alertController.addAction(okButton)
        //        alertController.addAction(cancelButton)
        //        present(alertController, animated: true, completion: nil)
    }
    func noFinishedDeliveriesAlert(currentTrip: Trip) {
        
        let alertController = MDCAlertController(title: "Unable To Create A New Trip", message: "There need to be completed deliveries in the current trip for you to create a new trip")
        let okButton = MDCAlertAction(title: "OK") { (action) in
            
        }
        
        //            let cancelButton = MDCAlertAction(title: "Cancel", emphasis: .low, handler: nil)
        
        alertController.addAction(okButton)
        //            alertController.addAction(cancelButton)
        
        present(alertController, animated:true, completion:nil)
        
        
        
        
        //        let alertController = UIAlertController(title: "New Trip?", message: "This will delete all unfinished deliveries from the current trip, are you sure you want to create a new Trip?", preferredStyle: .alert)
        //        let okButton = UIAlertAction(title: "Yes", style: .default) { (tapped) in
        //
        //            DeliveryController.deleteUnFinDelFor(trip: currentTrip)
        //            self.newTripButtonTapped(self)
        //
        //        }
        //        let cancelButton = UIAlertAction(title: "No", style: .cancel) { (cancel) in
        //
        //        }
        //        alertController.addAction(okButton)
        //        alertController.addAction(cancelButton)
        //        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - New Trip Alert
    /// If the user hits ok, all unfinished deliveries for this trip will be deleted, if the user hits cancel, they will not be deleted.
    func newTripAlert(currentTrip: Trip) {
        
        let alertController = MDCAlertController(title: "New Trip?", message: "This will delete all unfinished deliveries from the current trip, are you sure you want to create a new Trip?")
        let okButton = MDCAlertAction(title: "Yes") { (action) in
            DeliveryController.deleteUnFinDelFor(trip: currentTrip)
            self.newTripButtonTapped(self)
        }
        
        let cancelButton = MDCAlertAction(title: "Cancel", emphasis: .low, handler: nil)
        
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated:true, completion:nil)
        
        
        
        
        //        let alertController = UIAlertController(title: "New Trip?", message: "This will delete all unfinished deliveries from the current trip, are you sure you want to create a new Trip?", preferredStyle: .alert)
        //        let okButton = UIAlertAction(title: "Yes", style: .default) { (tapped) in
        //
        //            DeliveryController.deleteUnFinDelFor(trip: currentTrip)
        //            self.newTripButtonTapped(self)
        //
        //        }
        //        let cancelButton = UIAlertAction(title: "No", style: .cancel) { (cancel) in
        //
        //        }
        //        alertController.addAction(okButton)
        //        alertController.addAction(cancelButton)
        //        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Confirm Delivery Alert
    ///Displays the confirm delivery alert
    func confirmDelivery(phoneNumber:String) {
        
        //        let alertController = MDCAlertController(title: "Is This Right?", message: "Are you sure you want to add \(address) to your trip")
        //        let okButton = MDCAlertAction(title: "Yes") { (action) in
        //            guard let coordinate = self.coordinate else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        //            // MARK: - AddPin
        //            self.delegate?.addPin(coord: coordinate, address: self.address, apt: self.apartmentText, subAddress: self.subAddress)
        //        }
        //
        //        let cancelButton = MDCAlertAction(title: "Cancel", emphasis: .low, handler: nil)
        //
        //        alertController.addAction(okButton)
        //        alertController.addAction(cancelButton)
        //
        //        present(alertController, animated:true, completion:nil)
        
        
        
        let alertController = UIAlertController(title: "Is This Right?", message: "Are you sure you want to add \(address) to your trip", preferredStyle: .alert)
        
        
        let okButton = UIAlertAction(title: "Yes", style: .default) { (yes) in
            
            guard let coordinate = self.coordinate else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            // MARK: - AddPin
            self.delegate?.addPin(coord: coordinate, address: self.address, apt: self.apartmentText, subAddress: self.subAddress, phoneNumber: phoneNumber)
            
        }
        let cancelButton = UIAlertAction(title: "No", style: .cancel) { (cancel) in
            
        }
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func addPhoneNumberAlert(){
        let alertController = UIAlertController(title: "Phone Number", message: "Please Enter The Phone Number For This Location", preferredStyle: .alert)
        
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Phone Number"
            textField.delegate = self
            textField.keyboardType = .phonePad
        }
        
        let okButton = UIAlertAction(title: "Confirm", style: .default) { (yes) in
            guard let textField = alertController.textFields?.first else {return}
            if textField.text?.count != 14 {
                self.checkIfRealPhoneNumber()}
            else {
                guard let text = textField.text?.filter({Int(String($0)) != nil}) else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                
                self.confirmDelivery(phoneNumber: text)
            }
            
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
        }
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func checkIfRealPhoneNumber(){
        
        let alertController = UIAlertController(title: "Not Enough Numbers", message: "Phone Number must have 10 Digits", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel) { (_) in
            self.addPhoneNumberAlert()
        }
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
}


// MARK: - TableView Delegate
extension AddressSearchViewController : UITableViewDelegate, UITableViewDataSource {
    // MARK: - Rows In section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Deselect Row
//        if let selectedRow = tableView.indexPathForSelectedRow {
//            tableView.deselectRow(at: selectedRow, animated: true)
//        }
        
        
        return searchResults.count
    }
    // MARK: - CellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let searchResult = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        
        cell.textLabel?.textColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        cell.detailTextLabel?.textColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        #warning("DeleteTestFunc")
//                TestFuncs.populateDeliveryTests(indexPath: indexPath, searchResults: searchResults)
        
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
            
            self.addPhoneNumberAlert()
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
    /// Phone number entering format
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText:String = textField.text else {return true}
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil { return false }
        let newCount:Int = currentText.count + string.count - range.length
        let addingCharacter:Bool = range.length <= 0
        
        if(newCount == 1){
            textField.text = addingCharacter ? currentText + "(\(string)" : String(currentText.dropLast(2))
            return false
        }else if(newCount == 5){
            textField.text = addingCharacter ? currentText + ") \(string)" : String(currentText.dropLast(2))
            return false
        }else if(newCount == 10){
            textField.text = addingCharacter ? currentText + "-\(string)" : String(currentText.dropLast(2))
            return false
        }
        
        if(newCount > 14){
            return false
        }
        
        return true
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
    
    //    func populateDeliveryTests(indexPath: IndexPath) {
    //           let searchResult = searchResults[indexPath.row]
    //           let searchRequest = MKLocalSearch.Request(completion: searchResult)
    //           let search = MKLocalSearch(request: searchRequest)
    //
    //           search.start { (response, error) in
    //               self.coordinate = response?.mapItems[0].placemark.coordinate
    //               self.address = self.searchResults[indexPath.row].title
    //               self.subAddress = self.searchResults[indexPath.row].subtitle
    //               guard let coordinate = self.coordinate else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
    //               self.delegate?.addPin(coord: coordinate, address: self.address, apt: self.apartmentText, subAddress: self.subAddress)
    //           }
    //
    //
    //       }
    
}
