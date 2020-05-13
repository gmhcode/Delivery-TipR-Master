//
//  AppDelegate.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/1/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        LocationController.deleteDatabase()
//        TripController().deleteTrips()
//        DeliveryController.deleteALLDeliveries()
        //If there are no current trips, make one
        if  TripController.getCurrentTrip() == nil {
            let _ = TripController.createNewTrip()
        }
        if let user = UserController.fetchUser(){
            DeliveryController.BackEnd.fetchAllDeliveries(for: user) { (dict) in
//                print("DICT  🏀",dict)
                let itemsArray = dict!["Items"] as? Array<[String:AnyObject]>
                print("DICT  🏀",itemsArray![1]["latitude"])
                for i in itemsArray! {
                    if let address = i["address"] as? String,
                    let latitude = i["latitude"] as? String,
                    let longitude = i["logitude"] as? String,
                    let subaddress = i["id"] as? String,
                    let phoneNumber = i["locationId"] as? String,
                    let tripId = i["tripId"] as? String,
                    let userId = i["userId"] as? String,
                    let id = i["id"] as? String,
                    let locationId = i["locationId"] as? String,
                    let date = i["date"] as? String,
                    let tip = i["tipAmount"] as? String{
                        
                        let lat = Double(latitude)
                        let lon = Double(longitude)
                        let location = LocationController.createLocation(address: address, latitude: lat ?? 0, longitude: lon ?? 0, subAddress: subaddress, phoneNumber: phoneNumber)
                        
//                        let trip = TripController.getTrip(from: tripId)
                        let tipAmount = Float(tip)
                        DeliveryController.createDelivery(userId: userId, id: id, address: address, locationId: locationId, tripId: tripId, date: date, latitude: latitude, longitude: longitude, tipAmount: tipAmount ?? 0)
                    }
                    
                    
                }
            }
        }
       
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

   

}

