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
    
    var drawerView : UIView!
    var tabViewController : TabViewController?
    var drawerPanGestureRecognizer : UIPanGestureRecognizer!
    
    
    static var MapVC : MapViewController!
    lazy var topDrawerTarget = self.view.frame.maxY / 9
    lazy var bottomDrawerTarget = self.view.frame.maxY * 0.9
    let locationManager = CLLocationManager()
//       checkLocationServices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        MapViewController.MapVC = self
        mapView.delegate = self
        setDrawerFunctionality()
        checkLocationServices()
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
}

extension MapViewController : MKMapViewDelegate {
    // MARK: - ViewForAnnotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let address = annotation.title!!
        
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: address)
        
        view?.canShowCallout = true
        view?.annotation = annotation
        view?.displayPriority = .required
        return view
    }
    
    /// disables the ability to select user location annotation. if its selected, it can mess up the add Tip VC
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
    func addPin(coord: CLLocationCoordinate2D, address: String, apt: String?, subAddress: String) {
        
        LocationController.createLocation(address: address, latitude: coord.latitude, longitude: coord.longitude, subAddress: subAddress)
        let location = LocationController.getALLLocations()[0]
//        LocationController.getLocation(with: location.address)
        LocationController.deleteDatabase()
        
    }
    
    
}
