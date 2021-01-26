//
//  AccountViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/22/21.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var separetorView: UIView!
    @IBOutlet weak var middleView: UIView!
    
    private let sideMenu = LaunchSideMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeViewComponent()
    }

    private func changeViewComponent(){
        backgroundView.layer.opacity = Float(72)
        backgroundView.alpha = 0.7
        
        navigationView.layer.masksToBounds = true
        navigationView.layer.cornerRadius = 30.0
        navigationView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        separetorView.layer.cornerRadius = separetorView.frame.height / 2
        separetorView.layer.borderWidth = 1
        separetorView.layer.borderColor = UIColor(named: "SeparetorBorder_Color")!.cgColor
        
        middleView.layer.borderColor = UIColor(named: "Black_Color")!.cgColor
        middleView.layer.borderWidth = 2
        middleView.layer.cornerRadius = 30.0
    }
    
    @IBAction func sideMenuPressed(_ sender: Any) {
        sideMenu.setupBackgroundView()
        sideMenu.delegate = self
    }
    
    private func presentSignInVC(){
        let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SIGNIN_SCREEN") as! SignInViewController
        signInVC.modalTransitionStyle = .coverVertical
        signInVC.modalPresentationStyle = .fullScreen
        if let window = UIApplication.shared.windows.first{
            window.rootViewController = signInVC
            window.makeKeyAndVisible()
        }
        
    }
    
    private func presentAddressVC(){
        let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SETUP_ADDRESS_SCREEN") as! AddressViewController
        addressVC.modalTransitionStyle = .coverVertical
        addressVC.modalPresentationStyle = .fullScreen
        self.present(addressVC, animated: true, completion: nil)
    }
    
}

extension AccountViewController : SideMenuDelegate {
    
    func didPressedAddress() {
        presentAddressVC()
    }
    
    func didPressedLogOut() {
        
        let alert = UIAlertController(title: "Log Out!", message: "Do you want to log out", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (yesAction) in
            self.presentSignInVC()
        }
        
        let noAction = UIAlertAction(title: "No", style: .default) { (noAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
