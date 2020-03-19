//
//  TextFields.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 3/19/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

//class PhoneNumberTextField : UITextField, UITextFieldDelegate {
//    
//     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let currentText:String = textField.text else {return true}
//        if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil { return false }
//        let newCount:Int = currentText.count + string.count - range.length
//        let addingCharacter:Bool = range.length <= 0
//        
//        if(newCount == 1){
//            textField.text = addingCharacter ? currentText + "(\(string)" : String(currentText.dropLast(2))
//            return false
//        }else if(newCount == 5){
//            textField.text = addingCharacter ? currentText + ") \(string)" : String(currentText.dropLast(2))
//            return false
//        }else if(newCount == 10){
//            textField.text = addingCharacter ? currentText + "-\(string)" : String(currentText.dropLast(2))
//            return false
//        }
//        
//        if(newCount > 14){
//            return false
//        }
//        
//        return true
//    }
//    
//    
//}

