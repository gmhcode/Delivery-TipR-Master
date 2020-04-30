//
//  BackEndController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/29/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation
struct BackEndUrls {
    
    static let postDeliveryUrl = URL(string: "https://sri4rxxjh7.execute-api.us-west-2.amazonaws.com/dev/delivery")!
    
    
    static func updateDeliveryUrl(delivery: Delivery) -> URL? {
        let urlString = "https://sri4rxxjh7.execute-api.us-west-2.amazonaws.com/dev/delivery" + "/\(delivery.userID)/\(delivery.id)"
        if let url = URL(string: urlString) {
            return url
        }else {
            return nil
        }
    }
    
    static func deleteDeliveryUrl(delivery: Delivery) -> URL? {
        let urlString = "https://sri4rxxjh7.execute-api.us-west-2.amazonaws.com/dev/delivery" + "/\(delivery.userID)/\(delivery.id)"
        if let url = URL(string: urlString) {
            return url
        }else {
            return nil
        }
    }
}
