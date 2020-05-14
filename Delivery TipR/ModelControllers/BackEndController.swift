//
//  BackEndController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 5/13/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation
struct BackEndController {
    static func signInFetch(email: String, uuid: String, username: String, password: String) {
        
        if UserController.fetchUser() == nil {
            let _ = UserController.createUser(email: email, uuid: uuid, username: email, password: password)
        }
        
        if let user = UserController.fetchUser() {
            DispatchQueue.global(qos: .userInitiated).async {
                
                DeliveryController.BackEnd.fetchAllDeliveries(for: user) { (dictionary) in
                    
                    guard let dictionary = dictionary else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                    
                    
                    DeliveryController.BackEnd.parseFetchedDeliveries(dictionary: dictionary)
                    
                }
            }
        }
    }
}
