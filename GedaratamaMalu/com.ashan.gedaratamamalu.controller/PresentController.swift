//
//  PresentController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 12/28/20.
//

import Foundation

import UIKit

class PresentController {
    
    public func isLogedIn() -> Bool {
        let userDefault = UserDefaults.standard
        return userDefault.bool(forKey: "IS_LOGGING") 
        
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
}
