//
//  Views.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/4/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
class AnnotationViews {
    
    static let finishedDeliveryView = { () -> UILabel in
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
        label.backgroundColor = #colorLiteral(red: 0.7141265273, green: 0.7141265273, blue: 0.7141265273, alpha: 0.8205637792)
        label.numberOfLines = 0
        label.font = label.font.withSize(35)
        label.layer.cornerRadius = label.frame.width / 2
        label.clipsToBounds = true
        label.layer.borderWidth = 1
        
        label.textAlignment = .center
        
//        let subView = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
//        subView.backgroundColor = #colorLiteral(red: 0.9400669932, green: 0.9400669932, blue: 0.9400669932, alpha: 1)
//        subView.numberOfLines = 0
//        subView.font = label.font.withSize(35)
//        subView.layer.cornerRadius = subView.frame.width / 2
//        subView.clipsToBounds = true
//        subView.textAlignment = .center
//        label.addSubview(subView)
//
//        subView.translatesAutoresizingMaskIntoConstraints = false
//        subView.centerXAnchor.constraint(equalTo: subView.superview!.centerXAnchor).isActive = true
//        subView.centerYAnchor.constraint(equalTo: subView.superview!.centerYAnchor).isActive = true
        
        
        
        return label
    }()
    //TESTTEST
    static let unfinishedDeliveryView = { () -> UILabel in
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
        label.backgroundColor = .red
        label.numberOfLines = 0
        label.font = label.font.withSize(35)
        label.textAlignment = .center
        return label
    }()
}
