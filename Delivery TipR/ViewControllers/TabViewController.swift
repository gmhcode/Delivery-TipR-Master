//
//  TabViewController.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/4/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class TabViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pullTabView: UIView!
    @IBOutlet weak var tripsButton: UIButton!
    @IBOutlet weak var advancedButton: UIButton!
    
    lazy var addressSearchViewController : AddressSearchViewController =  {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddressSearchViewController") as! AddressSearchViewController
        
        viewController.view.frame = containerView.bounds
        viewController.delegate = MapViewController.MapVC
        
        return viewController
    }()
    lazy var navView : NavViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "NavViewController") as! NavViewController
        
        viewController.view.frame = containerView.bounds
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        setupAddressSearch()
        containerView.addSubview(addressSearchViewController.view)
        
    }
    
 
    override func viewDidLayoutSubviews() {
       
        setupViews()
    }
    
    @IBAction func tripButtonTapped(_ sender: Any) {
        tripsButton.pulsate()
        IphoneSystem.vibrate()
        if containerView.subviews.contains(navView.view) {
            navView.view.removeFromSuperview()
            containerView.addSubview(addressSearchViewController.view)
            MapViewController.MapVC.openDrawer()
        } else {
             MapViewController.MapVC.drawerTogglePosition()
        }

    }
    @IBAction func advancedButtonTapped(_ sender: Any) {
   
        advancedButton.pulsate()
        IphoneSystem.vibrate()
        
        if containerView.subviews.contains(addressSearchViewController.view) {
            addressSearchViewController.view.removeFromSuperview()
//            setupNav()
            let advancedVC = navView.viewControllers[0] as? AdvancedViewController
            advancedVC?.setupTripInfoView()
            containerView.addSubview(navView.view)
            MapViewController.MapVC.openDrawer()
        } else {
             MapViewController.MapVC.drawerTogglePosition()
        }
        
        
        
    }

    
//    func setupAddressSearch() {
//        guard addressSearchViewController == nil else{return}
//        if addressSearchViewController != nil{return}
//        addressSearchViewController = {
//            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//
//            let viewController = storyboard.instantiateViewController(withIdentifier: "AddressSearchViewController") as! AddressSearchViewController
//
//            viewController.view.frame = containerView.bounds
//            viewController.delegate = MapViewController.MapVC
//
//            return viewController
//        }()
//    }
//
//    func setupNav() {
//        guard navView == nil else{return}
//        navView = {
//            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//
//            let viewController = storyboard.instantiateViewController(withIdentifier: "NavViewController") as! NavViewController
//
//            viewController.view.frame = containerView.bounds
//
//            return viewController
//        }()
//    }
    
    func setupViews() {
        pullTabView.layer.borderWidth = 2
        pullTabView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        tripsButton.layer.borderWidth = 1
        tripsButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tripsButton.setGradientBackground(colorOne: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), colorTwo: #colorLiteral(red: 0.8619334698, green: 0.8619334698, blue: 0.8619334698, alpha: 1))
        tripsButton.layer.masksToBounds = true
        
        advancedButton.layer.borderWidth = 1
        advancedButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        advancedButton.setGradientBackground(colorOne: #colorLiteral(red: 0.8619334698, green: 0.8619334698, blue: 0.8619334698, alpha: 1), colorTwo: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        advancedButton.layer.masksToBounds = true
    }
}
