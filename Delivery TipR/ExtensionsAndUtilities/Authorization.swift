//
//  Authentication.swift
//  Delivery TipR
//
//  Created by Greg Hughes on 4/1/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
import AWSMobileClient
//class User : Codable {
//    
//    
//    let email : String
//    let uuid : String
//    let username : String
//    let password : String
//    
//    init(email: String, uuid: String, username: String, password: String) {
//        self.email = email
//        self.uuid = uuid
//        self.username = username
//        self.password = password
//    }
//}

//var theUser : User!
class Authorization {
    
    static var global = Authorization()
    var theUser : User!
    
    func initialize() {
        AWSMobileClient.default().initialize { (userState, error) in
            if let userState = userState {
                print("UserState: \(userState.rawValue)")
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func signOut(){
        AWSMobileClient.default().signOut()
    }
    
    func newPassword(email:String?,newPassword:String?,reTypePassword:String?,confirmationCode:String?,vc:UIViewController,completion:@escaping (ConfirmationState?)->Void) {
        
        guard let email = email,
            let password = newPassword,
            let retypePW = reTypePassword,
            let confirmationCode = confirmationCode else { return }
        
        if password != retypePW {
            passwordDontMatchAlert(vc: vc)
            return
        }
        
        AWSMobileClient.default().confirmForgotPassword(username: email, newPassword: password, confirmationCode: confirmationCode) { (forgotPasswordResult, error) in
            if let forgotPasswordResult = forgotPasswordResult {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .done:
                    print("Password changed successfully")
                    completion(.emailWillBeSent)
                default:
                    print("Error: Could not change password.")
                    completion(nil)
                }
            } else if let error = error {
                print("Error occurred: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func forgotPassword(email:String?, vc:UIViewController,completion:@escaping (ForgotPasswordState?)->Void){
        guard let email = email else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); completion(nil);return}
        
        AWSMobileClient.default().forgotPassword(username: email) { (forgotPasswordResult, error) in
            if let forgotPasswordResult = forgotPasswordResult {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .confirmationCodeSent:
                    print("Confirmation code sent via \(forgotPasswordResult.codeDeliveryDetails!.deliveryMedium) to: \(forgotPasswordResult.codeDeliveryDetails!.destination!)")
                    self.confirmationCodeSentAlert(vc: vc)
                    completion(.confirmationCodeSent)
                default:
                    print("Error: Invalid case.")
                    completion(nil)
                }
            } else if let error = error as? AWSMobileClientError{
                print("Error occurred: \(error)")
                
                switch error {
                case  .userNotFound(let message):
                    print(message)
                    self.userNotFoundError(vc: vc)
                    
                default:
                    break
                }
                completion(nil)
            }
        }
    }
    /// - Parameters:
    ///   - vc: The current ViewController
    func signIn(email: String?, password: String?, vc:UIViewController) {
        
        guard let email = email,
            let password = password else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        
        AWSMobileClient.default().signIn(username: email, password: password) { [weak self] (signInResult, error) in
            if let error = error as? AWSMobileClientError   {
                
                switch error {
                case .notAuthorized(let message):
                    print("\(message), 🎫")
                    self?.invalidUsernameOrPasswordAlert(vc: vc)
                    break
                default:
                    break
                }
                //                print()
            } else if let signInResult = signInResult {
                switch (signInResult.signInState) {
                case .signedIn:
                    print("User is signed in.")
                case .smsMFA:
                    print("SMS message sent to \(signInResult.codeDetails!.destination!)")
                default:
                    print("Sign In needs info which is not et supported.")
                }
            }
        }
    }
    
    func resendConfirmationCode() {
        AWSMobileClient.default().resendSignUpCode(username: theUser.email, completionHandler: { (result, error) in
            if let signUpResult = result {
                print("A verification code has been sent via \(signUpResult.codeDeliveryDetails!.deliveryMedium) at \(signUpResult.codeDeliveryDetails!.destination!)")
            } else if let error = error {
                print("\(error.localizedDescription)")
            }
        })
    }
    
    
    func confirm(confirmationCode:String, vc:UIViewController, completion: @escaping (ConfirmationState?)->()) {
        
        
        AWSMobileClient.default().confirmSignUp(username: theUser.email, confirmationCode: confirmationCode) { (signUpResult, error) in
            if let signUpResult = signUpResult {
                switch(signUpResult.signUpConfirmationState) {
                case .confirmed:
                    
//                    self.confirmedSuccessAlert(vc:vc)
                    completion(.accepted)
                    print("User is signed up and confirmed.")
                case .unconfirmed:
                    print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                case .unknown:
                    print("Unexpected case")
                }
            } else if let error = error as? AWSMobileClientError {
                print("\(error.localizedDescription)")
                switch error {
                case .codeMismatch(let message):
                    self.errorMessageAlert(vc: vc, message: message)
                    break
                default:
                    break
                }
            }
            completion(nil)
        }
    }
    
    func signUp(vc:UIViewController, email: String, password: String, username: String, uuid: String, completion: @escaping(ConfirmationState?)->Void){
        
        
        
        AWSMobileClient.default().signUp(username: email, password: password, userAttributes: ["email":email,"custom:uuid":uuid]) { (signUpResult, error) in
            if let signUpResult = signUpResult {
                
                switch(signUpResult.signUpConfirmationState) {
                case .confirmed:
                    print("🏊🏾‍♂️ User is signed up and confirmed.")
                    //TODO : Alert saying the user already exists
                    self.confirmedEmailExistsAlert(vc: vc)
                    completion(nil)
                    
                    
                case .unconfirmed:
                    
                    print("🚣🏼‍♂️ User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                    
                    let user = UserController.createUser(email: email, uuid: uuid, username: username, password: password)
                    self.theUser = user
                    completion(.emailWillBeSent)
                    
                case .unknown:
                    print("Unexpected case")
                    completion(nil)
                }
            } else if let error = error {
                if let error = error as? AWSMobileClientError {
                    switch(error) {
                        
                    case .usernameExists(let message):
                        print(message, " 🥇")
                        //TODO : Alert saying the user already exists
                        let user = UserController.createUser(email: email, uuid: uuid, username: username, password: password)
                        self.theUser = user
                        completion(.emailWillBeSent)
                        self.unconfirmedEmailExistsAlert(vc: vc)
                        break
                    case .invalidParameter(let message):
                        self.errorMessageAlert(vc: vc, message: message)
                    default:
                        break
                    }
                    
                }
                print("\(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    private func userNotFoundError(vc:UIViewController) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Email Not Found", message: "Unable to locate and users with the provided email address", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okButton)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func confirmationCodeSentAlert(vc:UIViewController){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Confirmation Sent", message: "The confirmation code has been sent to your email address", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okButton)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func invalidUsernameOrPasswordAlert(vc: UIViewController) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Invalid", message: "Invalid Username or Password", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okButton)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    
    func passwordDontMatchAlert(vc:UIViewController) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Invalid Passwords", message: "The passwords do not match", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okButton)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func confirmedEmailExistsAlert(vc:UIViewController) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Email Already Exists", message: "An account with the given email already exists and is confirmed ", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .cancel) { (ok) in
                
            }
            alertController.addAction(okButton)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func unconfirmedEmailExistsAlert(vc:UIViewController) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Email Already Exists", message: "An account with the given email already exists.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okButton)
            //        alertController.show()
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    private func confirmedSuccessAlert(vc:UIViewController) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Success", message: "The email has been confirmed.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okButton)
            //        alertController.show()
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func errorMessageAlert(vc: UIViewController, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okButton)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    //    private func errorMessageAlert(vc:UIViewController, message:String) {
    //         DispatchQueue.main.async {
    //                let alertController = UIAlertController(title: "Invalid Parameter", message: message, preferredStyle: .alert)
    //                let okButton = UIAlertAction(title: "Ok", style: .cancel)
    //                alertController.addAction(okButton)
    //                    vc.present(alertController, animated: true, completion: nil)
    //                }
    //    }
    
    enum ConfirmationState {
        case emailWillBeSent
        case accepted
    }
}

