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
    
    fileprivate var addressMV : AddressModelView!
    fileprivate var registerMV : RegisterModelView!
    fileprivate var profileInfo : Profile!
    fileprivate let alertView = ShowCustomAlertMessage()
    
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
        viewController.saveAddressButton.addTarget(self, action: #selector(billingSaveButtonDidPressed), for: .touchUpInside)
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
        
        let jwtToken = UserDefaults.standard.object(forKey: "JWT_TOKEN") as! String
        registerMV = RegisterModelView(jwtToken)
        addressMV = AddressModelView(jwtToken)
    
        registerMV.delegate = self
        addressMV.delegate = self
        
        //get profile infomation
        loadDefaultUserInfo()
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
    
    fileprivate func loadDefaultUserInfo(){
        
        let userName = UserDefaults.standard.object(forKey: "USER_NAME") as! String
        registerMV.getProfileInfoByUserName(UserName: userName)
        
    }
    
    @objc fileprivate func billingSaveButtonDidPressed(){
        if billingAddresVC.firstNameField.text!.isEmpty{
            billingAddresVC.firstNameField.setupRightCustomImage(imageName: "Empty_Icon", color: .red)
        } else if billingAddresVC.lastNameField.text!.isEmpty{
            billingAddresVC.lastNameField.setupRightCustomImage(imageName: "Empty_Icon", color: .red)
        } else if billingAddresVC.houseNoField.text!.isEmpty{
            billingAddresVC.houseNoField.setupRightCustomImage(imageName: "Empty_Icon", color: .red)
        } else if billingAddresVC.townNameField.text!.isEmpty {
            billingAddresVC.townNameField.setupRightCustomImage(imageName: "Empty_Icon", color: .red)
        } else if billingAddresVC.postalCodeField.text!.isEmpty{
            billingAddresVC.postalCodeField.setupRightCustomImage(imageName: "Empty_Icon", color: .red)
        } else if billingAddresVC.phoneField.text!.isEmpty {
            billingAddresVC.phoneField.setupRightCustomImage(imageName: "Empty_Icon", color: .red)
        } else if billingAddresVC.emailField.text!.isEmpty {
            billingAddresVC.emailField.setupRightCustomImage(imageName: "Empty_Icon", color: .red)
        } else {
            
            if Connectivity.isConnectedToInternet() {
                guard let firstName = billingAddresVC.firstNameField.text else { return }
                guard let lastName = billingAddresVC.lastNameField.text else { return }
                guard let houseNo = billingAddresVC.houseNoField.text else { return }
                guard let apartmentNo = billingAddresVC.apartmentNo.text else { return }
                guard let town = billingAddresVC.townNameField.text else { return }
                guard let postalCode = billingAddresVC.postalCodeField.text else { return }
                guard let phone = billingAddresVC.phoneField.text else { return }
                guard let email = billingAddresVC.emailField.text else { return }
                
                guard let coordinate = billingAddresVC.selectedCoordinate else { return }
                
                let addressType = AddressType(id: 141, type: "Billing", status: true, date: Date().getFormattedDate())
                
                let addressDetails = AddressDetail(id: 0, addressType: addressType, profile: profileInfo, firstName: firstName, lastName: lastName, houseNo: houseNo, apartmentNo: apartmentNo, city: town, postalCode: postalCode, latitude: String(coordinate.latitude), longitude: String(coordinate.longitude), mobile: phone, email: email)
                
                addressMV.saveAddressInfomation(addressDetails)
            } else {
                showAlertMesage(AlertMessage: "No Internet Connection", AlertImage: UIImage(named: "InternetConnection_Icon")!, ButtonTitle: .relaunch)
            }
        }
    }
    
    fileprivate func showAlertMesage(AlertMessage message : String,AlertImage image : UIImage, ButtonTitle : ButtonType){
        
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        
        alertView.frame = window.frame
        
        alertView.errorImageView.image = image
        alertView.errorMessageLabel.attributedText = NSAttributedString(string: message, attributes: [
                                                                            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        alertView.errorButton.setTitle(ButtonTitle.rawValue, for: .normal)
        alertView.errorButton.addTarget(self, action: #selector(dismissAlertView(_:)), for: .touchUpInside)
        
        view.addSubview(alertView)
    }
    
    @objc fileprivate func dismissAlertView(_ sender : UIButton){
        
        guard let title = sender.currentTitle else { return }
        
        switch title {
        case "Done":
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.billingAddresVC.clearFields()
                self.alertView.removeFromSuperview()
            }
            break
        case "Retry":
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
            }
            break
        case "Relaunch":
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
            break
        default:
            break
        }
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

//MARK:- RegistrationDelegate
extension AddressViewController : RegistrationDelegate{
    
    func getProfileInfo(_ profile: Profile?) {
        if let info = profile {
            billingAddresVC.firstNameField.text = info.firstName
            billingAddresVC.lastNameField.text = info.lastName
            billingAddresVC.phoneField.text = info.mobile
            billingAddresVC.emailField.text = info.email
            profileInfo = info
        }
    }
    
    func getResponse(_ response: ApiResponse) { }
    
    func getUniqueFieldResult(_ field: String, _ result: Bool) { }
    
}

//MARK:- AddressDelegate
extension AddressViewController : AddressDelegate {
    
    func getBillingAddressInfo(BillingAddress details: AddressDetail) { }
    
    func showCustomAlertMessage(HttpCode code: Int) {
        
        switch HttpStatus(rawValue: code) {
        
        case .created:
            showAlertMesage(AlertMessage: "Done..! \n Billing Address has been successfully saved.", AlertImage: UIImage(named: "Intraduction2")!, ButtonTitle: .done)
            break
        case .internalServerError:
            showAlertMesage(AlertMessage: "Server Error..! \n The Billing Address was unsuccessfully saved.", AlertImage: UIImage(named: "ServerError_Image")!, ButtonTitle: .retry)
            break
        case .badRequest:
            showAlertMesage(AlertMessage: "Server Error..! \n The Billing Address was unsuccessfully saved.", AlertImage: UIImage(named: "ServerError_Image")!, ButtonTitle: .retry)
            break
        case .notFound:
            break
        case .none:
            break
        }
        
    }
}
