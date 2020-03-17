//
//  Extensions.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/1/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//


import UIKit

func getAverageTipString(deliveries: [Delivery]) -> String {
    let average = Double(deliveries.map({$0.tipAmonut}).reduce(0,+) / Float(deliveries.count)).doubleToMoneyString()
    return average
}
func getAverageTip(deliveries:[Delivery]) -> Double {
    let average = Double(deliveries.map({$0.tipAmonut}).reduce(0,+) / Float(deliveries.count))
    return average
}

extension Double {
    func doubleToMoneyString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = .current
        return numberFormatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}


extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.80
        pulse.toValue = 1
        pulse.initialVelocity = 0.5
        layer.add(pulse, forKey: nil)
    }
    func blur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.7
        self.addSubview(blurEffectView)
    }
}


extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
    
    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
           UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
           let graphicsContext = UIGraphicsGetCurrentContext()
           graphicsContext?.setFillColor(color)
           let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
           graphicsContext?.fill(rectangle)
           let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return rectangleImage!
       }
}
public extension UIAlertController {
    
    func show() {
        DispatchQueue.main.async {
            let win = UIWindow(frame: UIScreen.main.bounds)
            let vc = UIViewController()
            vc.view.backgroundColor = .clear
            win.rootViewController = vc
            win.windowLevel = UIWindow.Level.alert + 1
            win.makeKeyAndVisible()
            vc.present(self, animated: true, completion: nil)
        }
        
    }
}

extension Date {
    
    var asString: String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter.string(from: self)
        
    }
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    var isInThisYear:  Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(as: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
}

struct IphoneSystem {
    static func vibrate() {
         if #available(iOS 10.0, *) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
         }
     }
}
