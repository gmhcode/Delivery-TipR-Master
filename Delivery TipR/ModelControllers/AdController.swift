//
//  AdController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 5/22/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation
import GoogleMobileAds
class AdController {
    var bannerView: GADBannerView = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: 320, height: 50)))
    
    static func initialize() {
         GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    func addBannerViewToView(_ bannerView: GADBannerView, vc: MapViewController) {
        
     bannerView.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(bannerView)
        vc.view.addConstraints(
       [NSLayoutConstraint(item: bannerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: vc.drawerView,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: bannerView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: vc.view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0)
       ])
        bannerView.adUnitID = Keys.BANNER_AD_UNIT_ID
        bannerView.rootViewController = vc
        bannerView.delegate = vc
    }
    func loadAd() {
        let request =  GADRequest()
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["EA02BBB4-2258-4BFE-9B69-2640539B551F"]
////            = ["EA02BBB4-2258-4BFE-9B69-2640539B551F"]

        bannerView.load(request)
    }
}
