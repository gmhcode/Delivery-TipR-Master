//
//  MapViewDirections.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/11/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
extension MapViewController {
    
    ///Gets directions and sets the polyline to the delivery Locations
    func directions(){
        mapView.removeOverlays(mapView.overlays)
        guard let currentTrip = TripController.getCurrentTrip() else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        let deliveries = DeliveryController.getUnfinishedTripDeliveries(trip: currentTrip)
        let locations = deliveries.map({LocationController.getExistingLocation(address: $0.address)}).joined()
        
        
        
        guard deliveries.count != 0,
            let location = CLLocationManager().location?.coordinate else {print("🔥❇️>>>\(#file) \(#line): guard ket failed<<<"); return }
        
        var previousCoord : CLLocationCoordinate2D?
        var request = MKDirections.Request()
        
        var directions : MKDirections {
            return MKDirections(request: request)
        }
        
        
        for (index,i) in locations.enumerated() {
            let coordinate = CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)
            
            
            if index == 0 {
                request = getDirections(starting: location, Ending: coordinate)
                
            }else {
                request = getDirections(starting: previousCoord!, Ending: coordinate)
            }
            
            directions.calculate { [unowned self] (response, error) in
                guard let response = response else { return }
                
                for (rIndex,_) in response.routes.enumerated() {
                    
                    let routes = response.routes
                    //This gets us the fastest route
                    let fastestRoute = routes.sorted(by: {$0.expectedTravelTime <
                        $1.expectedTravelTime})[0]
                    
                    if rIndex == 0 {
                        
                        let overlay = RouteOverlay(route: fastestRoute)
                        self.mapView.addOverlay(overlay.polyLine)
                        let rect = MKMapRect(x: overlay.polyLine.boundingMapRect.origin.x, y: overlay.polyLine.boundingMapRect.origin.y, width: overlay.polyLine.boundingMapRect.width * 2, height: overlay.polyLine.boundingMapRect.height * 2)
                        self.mapView.setVisibleMapRect(rect, animated: true)
                        
                        //breaking here makes sure that we dont get more than one route per location
                        break
                    }
                }
            }
            #warning("IDK what this was here for vv, uncomment if bugs are found")
            // If the loop is on the last location, this will create the polyline
//            if index == locations.count - 1 {
//                request = getDirections(starting: coordinate, Ending: location)
//                directions.calculate { [unowned self] (response, error) in
//                    guard let response = response else { return }
//
//                    for (_,_) in response.routes.enumerated() {
//
//                        let routes = response.routes
//                        let fastestRoute = routes.sorted(by: {$0.expectedTravelTime <
//                            $1.expectedTravelTime})[0]
//
//                        if index == 0 {
//                            let overlay = RouteOverlay(route: fastestRoute)
//                            self.mapView.addOverlay(overlay.polyLine)
//                            self.mapView.setVisibleMapRect(overlay.polyLine.boundingMapRect, animated: true)
//                        }
//                    }
//                }
//            }
            // Is its one at a time, it will only show one route to one location
            if MapSettings.routeDisplay == .oneAtATime {
                break
            }
            
            
            if previousCoord == nil {
                
                
            }
            previousCoord = coordinate
        }
        
    }
    
    func getDirections(starting: CLLocationCoordinate2D, Ending: CLLocationCoordinate2D) -> MKDirections.Request {
        
        let startingLocation            = MKPlacemark(coordinate: starting)
        let destination                 = MKPlacemark(coordinate: Ending)
        
        let request                     = MKDirections.Request()
        request.source                  = MKMapItem(placemark: startingLocation)
        
        request.destination             = MKMapItem(placemark: destination)
        request.transportType           = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    
}
class RouteOverlay: NSObject, MKOverlay {
    
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    var polyLine : MKPolyline
    
    var isSelected = false
    var id : String = ""
    //check
    init(route: MKRoute) {
        self.coordinate = route.polyline.coordinate
        self.boundingMapRect = route.polyline.boundingMapRect
        self.polyLine = route.polyline
    }
}

class MapOverlayController {
    
    var overlays : [MKOverlay] = []
    
}
class MapSettings {
    static var routeDisplay : RouteDisplay = .all
    
}
///determines whether one route will be displayed, or multiple
enum RouteDisplay {
    case oneAtATime
    case all
}
