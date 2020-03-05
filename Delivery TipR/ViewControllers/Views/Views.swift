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
        label.backgroundColor = .green
        label.numberOfLines = 0
        label.font = label.font.withSize(35)
        label.textAlignment = .center
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
