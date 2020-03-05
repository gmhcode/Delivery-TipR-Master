//
//  LocationManagerController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/4/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationManagerController: NSObject, CLLocationManagerDelegate{
    
//    let locationManager = CLLocationManager()
//    var mapView : MKMapView
//    
//    init(mapView: MKMapView) {
//        
//        self.mapView = mapView
//       
//        super.init()
//        checkLocationServices()
//    }
//    
//
//    
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
//        
//        //MARK: Set Region
//        //        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        //        let region = MKCoordinateRegion.init(center: center, span: mapView.region.span)
//        //        mapView.setRegion(region, animated: true)
//        
//        ///trying to get the coordinates of center so we can reverse geolocate and get the zipcode from the placemark
//        
//        
//        //        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
//        //            if let error = error {
//        //                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
//        //                return
//        //            }
//        //
//        //            if let placemark = placemarks?.first {
//        ////                print("🌙🌙🌙🌙🌙🌙🌙🌙\(placemark.postalCode!)")
//        //
//        //
//        //
//        ////                #error("when the postal code changes, we need to do a Database pull based off of the postal code")
//        ////                #error("Need to do a reverse geocode every time a new location is added, so we can get the postal address")
//        //            }
//        //        }
//        
//        
//        
//        /// uncommenting these will constantly center the screen on the users location. when user is moving
//        //        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        //        mapView.setRegion(region, animated: true)
//        
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        checkLocationAuthorization()
//        
//    }
//    ///sets location delegate and accuracy
//    func setUpLocationManager(){
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//    
//    func checkLocationServices(){
//        if CLLocationManager.locationServicesEnabled(){
//            setUpLocationManager()
//            checkLocationAuthorization()
//        }else {
//            #warning("give user alert to let them know location services isnt working")
//        }
//    }
//    ///makes sure the user hit yes on the map authorization
//    func checkLocationAuthorization(){
//        switch CLLocationManager.authorizationStatus(){
//        case .authorizedWhenInUse:
//            startTrackingUserLocation()
//            break
//        case .denied:
//            #warning ("make alert showing how to turn on permissions")
//            break
//        case .notDetermined:
//            locationManager.requestAlwaysAuthorization()
//            break
//        case .restricted:
//            break
//        case .authorizedAlways:
//            startTrackingUserLocation()
//            break
//        default:
//            break
//        }
//    }
//    
//    func startTrackingUserLocation(){
//        mapView.showsUserLocation = true
//        centerViewOnUserLocation()
//        locationManager.startUpdatingLocation()
//    }
//    
//    
//    //MARK: Initial Center On User
//    func centerViewOnUserLocation() {
//        
//        if let location = locationManager.location?.coordinate{
//            
//            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
//            let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
//            
//            mapView.setRegion(region, animated: true)
//            
//            //MARK:Meant to give us current zip code, may not need
//            //            geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
//            //                if let error = error {
//            //                    print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
//            //                    return
//            //                }
//            //                if let placemark = placemarks?.first {
//            //
//            //                    print("🌙🌙🌙🌙🌙🌙🌙🌙\(placemark.postalCode!)")
//            //                    //MARK: Initial set currentZip
//            //                    self.currentZip = "\(placemark.postalCode!)"
//            //                    print("🌺\(self.currentZip)")
//            //                }
//            //            }
//        }
//    }
}
