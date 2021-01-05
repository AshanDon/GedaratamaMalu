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
        
        return false
        
    }
    
    public func presentIntraductionVC() -> UIViewController{
        
        let intraductionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "INTRADUCTION_VIEW") as IntraductionViewController
        
        intraductionVC.modalPresentationStyle = .fullScreen
        
        return intraductionVC
        
    }
}
