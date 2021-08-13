//
//  TabBarViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/13/21.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    fileprivate lazy var customErrorAlert : ShowCustomAlertMessage = {
        let alertView = ShowCustomAlertMessage()
        alertView.frame = view.frame
        alertView.errorImageView.image = UIImage(named: "Intraduction1")
        alertView.errorButton.setTitle("Login", for: .normal)
        alertView.errorButton.addTarget(self, action: #selector(alertButtonDidPressed), for: .touchUpInside)
        return alertView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let selectedColor   = UIColor(named: "White_Color")!
        let unselectedColor = UIColor.black

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentEeeorAlert(_:)), name: NSNotification.Name("USER_NOT_FOUND_ALERT"), object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("USER_NOT_FOUND_ALERT"), object: nil)
        
    }
    
    @objc fileprivate func presentEeeorAlert(_ sender : NSNotification){
        let message = sender.object as! String
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.customErrorAlert.errorMessageLabel.text = message
            self.view.addSubview(self.customErrorAlert)
        }
    }
    
    @objc fileprivate func alertButtonDidPressed(){
        
        let signVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SIGNIN_SCREEN") as! SignInViewController
        signVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIApplication.shared.windows.first?.rootViewController = signVC
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                exit(0)
//            }
//        }
    }
}
