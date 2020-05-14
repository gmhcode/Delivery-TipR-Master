//
//  BackEndController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/29/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation
struct BackEndUrls {
    
    static let postDeliveryUrl = URL(string: UrlConstants.POST_DELIVERY)!
  
  static func getAllDeliveriesUrl(user: User) -> URL? {
    let urlString = UrlConstants.GET_ALL_DELIV + "/\(user.uuid)/\(user.uuid)"
      if let url = URL(string: urlString) {
          return url
      }else {
          return nil
      }
  }
  
  static func updateDeliveryUrl(delivery: Delivery) -> URL? {
    let urlString = UrlConstants.UPDATE_DELIVERY + "/\(delivery.userID)/\(delivery.id)"
      if let url = URL(string: urlString) {
          return url
      }else {
          return nil
      }
  }
  
  static func deleteDeliveryUrl(delivery: Delivery) -> URL? {
    let urlString = UrlConstants.DELETE_DELIVERY + "/\(delivery.userID)/\(delivery.id)"
      if let url = URL(string: urlString) {
          return url
      }else {
          return nil
      }
  }
}
