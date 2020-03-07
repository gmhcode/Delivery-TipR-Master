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
    
    var drawerView : UIView!
    var tabViewController : TabViewController?
    var drawerPanGestureRecognizer : UIPanGestureRecognizer!
    
    
    static var MapVC : MapViewController!
    lazy var topDrawerTarget = self.view.frame.maxY / 9
    lazy var bottomDrawerTarget = self.view.frame.maxY * 0.9
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        MapViewController.MapVC = self
        
        setDelegates()
        setDrawerFunctionality()
        checkLocationServices()
        
        let locations = LocationController.getALLLocations()
//        TripController.createNewTrip()
        
        LocationController.deleteDatabase()
        //        LocationManagerController(mapView: mapView)
        
        
        
        
        //        LocationController.createLocation(address: <#String#>, latitude: <#Double#>, longitude: <#Double#>, subAddress: <#String#>)
        
        //        let location = LocationController.getALLLocations()[0]
        //        LocationController.getLocation(with: location.address)
        //        DeliveryController.createDelivery(for: location)
        //        DeliveryController.getALLDeliveries()
        //
        //
        //
        //        let unfinishedDelivery = DeliveryController.getUnfinishedDeliveries(for: location)
        //        let finishedDelivery = DeliveryController.finishDelivery(delivery: unfinishedDelivery![0], tipAmount: 1.0)
        //        DeliveryController.getUnfinishedDeliveries(for: location)
        //        let finishedDeliveries = DeliveryController.getFinishedDeliveries(for: location)
        //
        //
        //
        //
        //        DeliveryController.deleteDeliveries()
        //        LocationController.deleteDatabase()
        
    }
    func setDelegates() {
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    // MARK: - Create Annotation
    func createAnnotation(address: String, subAddress: String, latitude: Double, longitude: Double) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = address
        annotation.subtitle = subAddress
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return annotation
    }
}
// MARK: - MapView Functions
extension MapViewController : MKMapViewDelegate {
    // MARK: - ViewForAnnotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let address = annotation.title!!
        //See if the Location exists in CoreData
        let location = LocationController.getLocation(with: address)
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: address)
        //If the location exists, run this code, if not, skip this code
        if location.isEmpty == false {
            //if there are NOT unfinished deliveries, set the image to finishedDeliveryView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: address)
            view?.image = UIImage(view: AnnotationViews.finishedDeliveryView)
         
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
        renderer.strokeColor = .blue
        return renderer
    }
}






// MARK: - AddressSearchViewControllerDelegate
extension MapViewController: AddressSearchViewControllerDelegate {
    
    
    // MARK: - Add Pin
    func addPin(coord: CLLocationCoordinate2D, address: String, apt: String?, subAddress: String) {
        //Create location
        let location = LocationController.createLocation(address: address, latitude: coord.latitude, longitude: coord.longitude, subAddress: subAddress)
        //Create Annotation
        let annotation = createAnnotation(address: location.address, subAddress: location.subAddress, latitude: location.latitude, longitude: location.longitude)
        
        let trip = TripController.getCurrentTrip()
        let delivery = DeliveryController.createDelivery(for: location, trip: trip[0])
        tableView.reloadData()
        //Add Annotation to map
        mapView.removeAnnotation(annotation)
        mapView.addAnnotation(annotation)
    }
}



// MARK: - TableView Functions
extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let trip = TripController.getCurrentTrip()
//        if trip.isEmpty {
//            trip = [TripController.createNewTrip()]
//        }
        let deliveries = DeliveryController.getTripDeliveries(trip: trip[0])
        return deliveries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapDeliveryCell", for: indexPath)
        
        let trip = TripController.getCurrentTrip()
        let deliveries = DeliveryController.getTripDeliveries(trip: trip[0]).sorted {$0.date < $1.date}
        cell.textLabel?.text = deliveries[indexPath.row].address
        
        
        return cell
    }
    
    
    
    
    
    
    
}
