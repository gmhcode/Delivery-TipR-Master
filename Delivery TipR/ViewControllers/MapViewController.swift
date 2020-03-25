//
//  ViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/1/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var centerOnLocationButton: UIButton!
    
    var drawerView : UIView!
    var tabViewController : TabViewController?
    var drawerPanGestureRecognizer : UIPanGestureRecognizer!
    
    
    static var MapVC : MapViewController!
    lazy var topDrawerTarget = self.view.frame.maxY / 9
    lazy var bottomDrawerTarget = self.view.frame.maxY * 0.9
    let locationManager = CLLocationManager()
    var selectedLocation : Location!
    var selectedDelivery : Delivery!
    var drawerIsOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MapViewController.MapVC = self
        setDelegates()
        setDrawerFunctionality()
        checkLocationServices()
         #warning("UNCOMMENT DIRECTIONS")
        directions()
        setViews()
        
    }
    @IBAction func centerOnLocationTapped(_ sender: Any) {
        centerViewOnUserLocation()
    }
    
    func setViews(){
        centerOnLocationButton.layer.borderWidth = 1
        centerOnLocationButton.layer.borderColor = #colorLiteral(red: 0.01656158641, green: 0.01656158641, blue: 0.01656158641, alpha: 1)
        centerOnLocationButton.layer.cornerRadius = //10
            centerOnLocationButton.frame.width / 2
        
        centerOnLocationButton.layer.shadowPath =
            UIBezierPath(roundedRect: self.centerOnLocationButton.bounds,
                         cornerRadius: self.centerOnLocationButton.layer.cornerRadius).cgPath
        centerOnLocationButton.layer.shadowColor = #colorLiteral(red: 0.1003180668, green: 0.1003180668, blue: 0.1003180668, alpha: 1)
        centerOnLocationButton.layer.shadowOpacity = 0.5
        centerOnLocationButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        centerOnLocationButton.layer.shadowRadius = 3
        centerOnLocationButton.layer.masksToBounds = false
        
    }
    
    func setDelegates() {
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTipSegue" {
            guard let destination = segue.destination as? AddTipViewController else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            destination.location = selectedLocation
            destination.delivery = selectedDelivery
        }
    }
}


// MARK: - MapView Functions
extension MapViewController : MKMapViewDelegate {
    // MARK: - ViewForAnnotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let address = annotation.title!!
        //See if the Location exists in CoreData
        let location = LocationController.getExistingLocation(address: address)
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: address)
        //If the location exists, run this code, if not, skip this code
        if location.isEmpty == false {
            //if there are NOT unfinished deliveries, set the image to finishedDeliveryView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: address)
            let deliveryView = AnnotationViews.finishedDeliveryView
            view?.image = UIImage(view: deliveryView)
            
         
        }
        view?.canShowCallout = true
        view?.annotation = annotation
        view?.displayPriority = .required
        return view
    }
    
    /// Disables the ability to select user location annotation. if its selected, it can mess up the add Tip VC
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        let userView = mapView.view(for: mapView.userLocation)
        userView?.isUserInteractionEnabled = false
        userView?.isEnabled = false
        userView?.canShowCallout = false
    }
    
    // MARK: - MapView Select
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        //        guard let annotation = view.annotation,
        //            let wrappedtitle = annotation.title,
        //            let title = wrappedtitle,
        //            let location = LocationController.locations[title] else {print("🔥❇️>>>\(#file) \(#line): guard ket failed<<<"); return  }
        //        MARK: SelectedLocation set
        //        LocationController.selectedLocation = location
        //        performSegue(withIdentifier: "addTip", sender: nil)
    }
    
    // MARK: - Directions Line
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.6856268275)
        renderer.lineWidth = 5
        return renderer
    }
}






// MARK: - AddressSearchViewControllerDelegate
extension MapViewController: AddressSearchViewControllerDelegate {
    
    
    // MARK: - Add Pin
    func addPin(coord: CLLocationCoordinate2D, address: String, apt: String?, subAddress: String, phoneNumber: String) {
       
        //Create location
        let location = LocationController.createLocation(address: address, latitude: coord.latitude, longitude: coord.longitude, subAddress: subAddress, phoneNumber: phoneNumber)

        
        
        if let trip = TripController.getCurrentTrip(){
            
        let _ = DeliveryController.createDelivery(for: location, trip: trip)
        createAddAnnotation(address: location.address, subAddress: location.subAddress, latitude: location.latitude, longitude: location.longitude)
//        //Create Annotation
//        let annotation = createAnnotation(address: location.address, subAddress: location.subAddress, latitude: location.latitude, longitude: location.longitude)
//        //Add Annotation to map
//        mapView.removeAnnotation(annotation)
//        mapView.addAnnotation(annotation)
        tableView.reloadData()
            #warning("UNCOMMENT DIRECTIONS")
        directions()
        }
    }
    // MARK: - Create Annotation
//    func createAnnotation(address: String, subAddress: String, latitude: Double, longitude: Double) -> MKPointAnnotation {
//        let annotation = MKPointAnnotation()
//        annotation.title = address
//        annotation.subtitle = subAddress
//        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        return annotation
//    }
    
    func createAddAnnotation(address: String, subAddress: String, latitude: Double, longitude: Double) {
        let annotation = MKPointAnnotation()
        annotation.title = address
        annotation.subtitle = subAddress
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(annotation)
    }
}



// MARK: - TableView Functions
extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Get the current trip
        guard let trip = TripController.getCurrentTrip() else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return 0}

        
        //Get the deliveries assigned to that trip
        let deliveries = DeliveryController.getTripDeliveries(trip: trip)
        //If there are no deliveries, hide the tableView
        tableView.isHidden = deliveries.count == 0 ? true : false
        #warning("UnComment Directions")
        directions()
        return deliveries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let trip = TripController.getCurrentTrip() else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return UITableViewCell()}
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapDeliveryCell", for: indexPath)
        // Sort the dates from earliest to greatest
        let deliveries = DeliveryController.getTripDeliveries(trip: trip).sorted {$0.date < $1.date}
        
        if deliveries[indexPath.row].isFinished == 1 {
            cell.backgroundColor = #colorLiteral(red: 0.1738502085, green: 0.187876761, blue: 0.2066913247, alpha: 0.7112573099)
            cell.textLabel?.textColor = #colorLiteral(red: 0.8430537581, green: 0.843195796, blue: 0.8430350423, alpha: 0.6826800073)
//            cell.textLabel?.textColor = cell.isSelected ? #colorLiteral(red: 0.1738502085, green: 0.187876761, blue: 0.2066913247, alpha: 0.7112573099) : #colorLiteral(red: 0.8430537581, green: 0.843195796, blue: 0.8430350423, alpha: 0.6826800073)
        }else {
            cell.backgroundColor = #colorLiteral(red: 0.8430537581, green: 0.843195796, blue: 0.8430350423, alpha: 0.6826800073)
            cell.textLabel?.textColor = .black
        }
        cell.textLabel?.text = deliveries[indexPath.row].address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let trip = TripController.getCurrentTrip() else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return }
        let deliveries = DeliveryController.getTripDeliveries(trip: trip).sorted {$0.date < $1.date}
        let location = LocationController.getExistingLocation(phoneNumber: deliveries[indexPath.row].locationId)
        
        
        let cell = tableView.cellForRow(at: indexPath)
        if deliveries[indexPath.row].isFinished == 1 {
            cell?.backgroundColor = #colorLiteral(red: 0.8430537581, green: 0.843195796, blue: 0.8430350423, alpha: 0.6826800073)
            cell?.textLabel?.textColor = #colorLiteral(red: 0.1738502085, green: 0.187876761, blue: 0.2066913247, alpha: 0.7112573099)
        }else {
            cell?.backgroundColor = #colorLiteral(red: 0.8430537581, green: 0.843195796, blue: 0.8430350423, alpha: 0.6826800073)
            cell?.textLabel?.textColor = .black
        }
        
        
        let delivery = deliveries[indexPath.row]
        selectedDelivery = delivery
        selectedLocation = location[0]
        performSegue(withIdentifier: "addTipSegue", sender: nil)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let trip = TripController.getCurrentTrip() else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return }
        let deliveries = DeliveryController.getTripDeliveries(trip: trip).sorted {$0.date < $1.date}
        
        
        let cell = tableView.cellForRow(at: indexPath)
        if deliveries[indexPath.row].isFinished == 1 {
            cell?.backgroundColor = #colorLiteral(red: 0.1738502085, green: 0.187876761, blue: 0.2066913247, alpha: 0.7112573099)
            cell?.textLabel?.textColor = #colorLiteral(red: 0.8430537581, green: 0.843195796, blue: 0.8430350423, alpha: 0.6826800073)
        }else {
            cell?.backgroundColor = #colorLiteral(red: 0.8430537581, green: 0.843195796, blue: 0.8430350423, alpha: 0.6826800073)
            cell?.textLabel?.textColor = .black
        }
    }
}
