//
//  PresentController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 12/28/20.
//

import Foundation

import UIKit

class PresentController {
    
    fileprivate let userDefault = UserDefaults.standard
    fileprivate var authenticationVM = AuthenticationViewModel()
    
    public func isLogedIn() -> Bool {
        genareteJWTToken()
        return userDefault.bool(forKey: "IS_LOGGING") 
        
    }
    
    fileprivate func genareteJWTToken(){
        
        let userName = userDefault.object(forKey: "USER_NAME") as? String ?? "AshanDon"
        let password = userDefault.object(forKey: "PASSWORD") as? String ?? "ashan123"
        
        authenticationVM.authDelegate = self
        
        authenticationVM.getUserProfile(userName, password)
        
    }
    
    public func presentIntraductionVC() -> UIViewController{
        
        let intraductionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "INTRADUCTION_VIEW") as IntraductionViewController
        
        intraductionVC.modalPresentationStyle = .fullScreen
        
        return intraductionVC
        
    }
    
    public func presentTabBarVC() -> UIViewController{
        
        let tabarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TAB_BAR_SCREEN") as TabBarViewController
        
        tabarVC.modalPresentationStyle = .fullScreen
        
        return tabarVC
        
    }
    
    @objc fileprivate func buttonDidPressed(){
        
    }
}

//MARK:- AuthenticationDelegate
extension PresentController : AuthenticationDelegate{
    func getTokenInfo(_ token: String, _ userName: String, _ password: String) {
        userDefault.set(token, forKey: "JWT_TOKEN")
        userDefault.set(userName, forKey: "USER_NAME")
        userDefault.set(password, forKey: "PASSWORD")
    }
    
    func getSignInError(_ message: String) {
        
        NotificationCenter.default.post(name: NSNotification.Name("USER_NOT_FOUND_ALERT"), object: message)
        
    }
}
