//
//  MapViewDrawer.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/4/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation

//MARK:Drawer Functionality
extension MapViewController {
    
    
    
    // MARK: - SetTabViewController
    fileprivate func setViewControllers() {
        
        tabViewController = {
            // Load Storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            // Instantiate View Controller
            let viewController = storyboard.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
            
            // Add View Controller as Child View Controller
            viewController.view.frame = drawerView.bounds
            viewController.view.layer.cornerRadius = 10
            viewController.view.layer.borderWidth = 1
            viewController.view.layer.borderColor = #colorLiteral(red: 0.2134257277, green: 0.2134257277, blue: 0.2134257277, alpha: 1)
            viewController.view.layer.masksToBounds = true
            
            self.addChild(viewController)
            //                   viewController.delegate = self
            
            return viewController
        }()
    }
    
    
    // MARK: - SetDrawerFunctionality
    func setDrawerFunctionality(){
        drawerView = createDrawerView()
        setViewControllers()
        drawerView.addSubview(tabViewController!.view)
        self.view.addSubview(drawerView)
        
        drawerPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureActivated))
        drawerPanGestureRecognizer.cancelsTouchesInView = false
        drawerView.addGestureRecognizer(drawerPanGestureRecognizer)
    }
 
    
    fileprivate func createDrawerView() -> UIView{
        
        //creating the frame parameters
        //set width to 80% of the viewcontroller width
        let width = self.view.frame.width
        //set height to 62% of the VC height
        let height = self.view.frame.height * 0.9
        //set x to the center of the view * 0.2 because the width is 80% the width of the view
        let x = CGFloat(0.0)
        let y = bottomDrawerTarget
        
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        let drawerView = UIView(frame: frame)
        drawerView.backgroundColor = .clear
        
        return drawerView
    }
    
    @objc func panGestureActivated(_ sender: UIPanGestureRecognizer) {
        
        switch drawerPanGestureRecognizer.state {
        case .began:
            
            panDrawer(withPanPoint: CGPoint(x: drawerView.center.x, y: drawerView.center.y + drawerPanGestureRecognizer.translation(in: drawerView).y))
            drawerPanGestureRecognizer.setTranslation(CGPoint.zero, in: drawerView)
        case .changed:
            panDrawer(withPanPoint: CGPoint(x: drawerView.center.x, y: drawerView.center.y + drawerPanGestureRecognizer.translation(in: drawerView).y))
            drawerPanGestureRecognizer.setTranslation(CGPoint.zero, in: drawerView)
        case .ended:
            drawerPanGestureRecognizer.setTranslation(CGPoint.zero, in: drawerView)
            panDidEnd()
            
        default:
            return
        }
    }
    
    fileprivate func panDrawer(withPanPoint panPoint: CGPoint) {
        if drawerView.frame.maxY < self.view.frame.maxY {
            
            // the /2 slows down then ability for the user to keep swiping past a certain point
            drawerView.center.y += drawerPanGestureRecognizer.translation(in: drawerView).y / 2
            
        } else {
            drawerView.center.y += drawerPanGestureRecognizer.translation(in: drawerView).y
        }
    }
    
    fileprivate func panDidEnd() {
        let aboveHalfWay = drawerView.frame.minY < ((self.view.frame.maxY) * 0.5)
        let velocity = drawerPanGestureRecognizer.velocity(in: drawerView).y
        if velocity > 400 {
            self.closeDrawer()
        } else if velocity < -400 {
            self.openDrawer()
        } else if aboveHalfWay {
            self.openDrawer()
        } else if !aboveHalfWay {
            self.closeDrawer()
        }
    }
    
    
    func openDrawer() {
        
        // Sets target locations of views & then animates.
        let target = topDrawerTarget
        self.userInteractionAnimate(view: self.drawerView, edge: self.drawerView.frame.minY, to: target, velocity: drawerPanGestureRecognizer.velocity(in: drawerView).y)
    }
    
    func closeDrawer() {
        let target = bottomDrawerTarget
        self.userInteractionAnimate(view: drawerView, edge: drawerView.frame.minY, to: target, velocity: drawerPanGestureRecognizer.velocity(in: drawerView).y)
        self.tabViewController?.addressSearchViewController?.dismissKeyboard()
        
    }
    fileprivate func userInteractionAnimate(view: UIView, edge: CGFloat, to target: CGFloat, velocity: CGFloat) {
        let distanceToTranslate = target - edge
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.97, initialSpringVelocity: abs(velocity) * 0.01, options: .curveEaseOut , animations: {
            
            //Sets view to new location (target
            view.frame =  view.frame.offsetBy(dx: 0, dy: distanceToTranslate)
            
        }, completion: { (success) in
            
            //               if success {
            //                   self.impact.prepare()
            //                   self.impact.impactOccurred()
            //               }
            
        })
    }
    
    @objc func drawerTogglePosition(){
        
        if Int(drawerView.frame.origin.y) == Int(topDrawerTarget) {
            
            closeDrawer()
            
        } else {
            openDrawer()
        }
    }
}
