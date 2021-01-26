//
//  AddressViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/24/21.
//

import UIKit

class AddressViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var addressSegmented: UISegmentedControl!
    @IBOutlet weak var conteinerView: UIView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    @IBOutlet weak var conteinerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!
    
    private lazy var touchView : UIView = {
       let tView = UIView()
        tView.isUserInteractionEnabled = true
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            tView.frame = window.frame
        }
        tView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        return tView
    }()
    
    private lazy var billingAddresVC : BillingAddressViewController = {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "BILLING_ADDRESS") as! BillingAddressViewController
        viewController.view.frame = conteinerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        viewController.didMove(toParent: self)
        viewController.delegate = self
        return viewController
    }()
    
    private lazy var shippingAddresVC : ShippingAddressViewController = {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SHIPPING_ADDRESS") as! ShippingAddressViewController
        viewController.view.frame = conteinerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        viewController.didMove(toParent: self)
        viewController.delegate = self
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSubView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeViewComponent()
        registerFromKeyboardEvent()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disappearFromKeyboardEvent()
    }
    @IBAction func getAddresCatogary(_ sender: Any) {
        if addressSegmented.selectedSegmentIndex == 0{
            print("Billing Address")
            conteinerViewHeight.constant = 538
            view.layoutIfNeeded()
            
            billingAddresVC.view.isHidden = false
            shippingAddresVC.view.isHidden = true
        } else {
            print("Shipping Address")
            conteinerViewHeight.constant = 435
            view.layoutIfNeeded()
            
            billingAddresVC.view.isHidden = true
            shippingAddresVC.view.isHidden = false
        }
    }
    
    @objc private func dismissAddressVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func changeViewComponent(){
        
        backgroundView.layer.opacity = Float(72)
        backgroundView.alpha = 0.7
        
        navigationBar.layer.opacity = Float(72)
        navigationBar.alpha = 0.7
        
        let navigationItem = UINavigationItem()
        navigationItem.title = ""
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAddressVC))
        navigationItem.leftBarButtonItem = cancelButton
        
        self.navigationBar.setItems([navigationItem], animated: false)
    }
    
    private func loadSubView(){
        conteinerView.addSubview(billingAddresVC.view)
        conteinerView.addSubview(shippingAddresVC.view)
        
        billingAddresVC.view.isHidden = false
        shippingAddresVC.view.isHidden = true
    }

    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    private func registerFromKeyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(_:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    private func disappearFromKeyboardEvent(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification : Notification){
        
        contentScrollView.isScrollEnabled = true
        contentScrollView.addSubview(touchView)
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let edgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyboardSize.height + 10), right: 0.0)
        
        contentScrollView.contentInset = edgeInsets
        
        contentScrollView.scrollIndicatorInsets = edgeInsets
    }
    
    @objc private func keyboardWillHidden(_ notification : Notification){
        touchView.removeFromSuperview()
        
        let edgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        contentScrollView.contentInset = edgeInsets
        
        contentScrollView.scrollIndicatorInsets = edgeInsets
    }
}

extension AddressViewController : MapDelegate{

    func presentedErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentedMapView(_ viewController: UIViewController, _ adressType: String) {
        let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MAP_VIEW") as! MapViewController
        mapVC.modalTransitionStyle = .crossDissolve
        mapVC.modalPresentationStyle = .fullScreen
        mapVC.addressType = adressType
        mapVC.delegate = viewController.self as? CustomLocationDelegate
        self.present(mapVC, animated: true, completion: nil)
    }
    
}
