//
//  BillingAddressViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/24/21.
//

import UIKit
import MapKit

protocol MapDelegate {
    func presentedMapView(_ viewController : UIViewController,_ adressType : String)
    func presentedErrorMessage(_ message : String)
}

class BillingAddressViewController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var houseNoField: UITextField!
    @IBOutlet weak var apartmentNo: UITextField!
    @IBOutlet weak var billingMap: MKMapView!
    @IBOutlet weak var townNameField: UITextField!
    @IBOutlet weak var postalCodeField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var saveAddressButton: UIButton!
    
    var delegate : MapDelegate!
    
    private lazy var mapTapView : UIView = {
        let mapView = UIView()
        mapView.isUserInteractionEnabled = true
        mapView.frame = billingMap.bounds
        mapView.backgroundColor = .clear
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMapView)))
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        houseNoField.delegate = self
        apartmentNo.delegate = self
        townNameField.delegate = self
        postalCodeField.delegate = self
        phoneField.delegate = self
        emailField.delegate = self
        
        billingMap.target(forAction: #selector(showMapView), withSender: nil)
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeViewComponent()
        
    }
    
    
    private func  changeViewComponent(){
        view.layer.cornerRadius = 20.0
        view.layer.borderColor = UIColor(named: "Black_Color")!.cgColor
        view.layer.borderWidth = 2.0
        
        //First Name Field
        firstNameField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        firstNameField.setTintColor(.darkGray)
        
        firstNameField.setBackgroundColor()
        
        firstNameField.setLeftPaddingPoints(5)
        
        firstNameField.setRightPaddingPoints(5)
        
        //Last Name Field
        lastNameField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        lastNameField.setTintColor(.darkGray)
        
        lastNameField.setBackgroundColor()
        
        lastNameField.setLeftPaddingPoints(5)
        
        lastNameField.setRightPaddingPoints(5)
        
        //House No Field
        houseNoField.attributedPlaceholder = NSAttributedString(string: "House no and street name", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        houseNoField.setTintColor(.darkGray)
        
        houseNoField.setBackgroundColor()
        
        houseNoField.setLeftPaddingPoints(5)
        
        houseNoField.setRightPaddingPoints(5)
        
        //Apartment No Field
        apartmentNo.attributedPlaceholder = NSAttributedString(string: "Apartment, suite, unit etc. (optional)", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        apartmentNo.setTintColor(.darkGray)
        
        apartmentNo.setBackgroundColor()
        
        apartmentNo.setLeftPaddingPoints(5)
        
        apartmentNo.setRightPaddingPoints(5)
        
        //Town Name Field
        townNameField.attributedPlaceholder = NSAttributedString(string: "Town/City", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        townNameField.setTintColor(.darkGray)
        
        townNameField.setBackgroundColor()
        
        townNameField.setLeftPaddingPoints(5)
        
        townNameField.setRightPaddingPoints(5)
        
        //Postal Code Field
        postalCodeField.attributedPlaceholder = NSAttributedString(string: "Postcode / Zip", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        postalCodeField.setTintColor(.darkGray)
        
        postalCodeField.setBackgroundColor()
        
        postalCodeField.setLeftPaddingPoints(5)
        
        postalCodeField.setRightPaddingPoints(5)
        
        //Phone Field
        phoneField.attributedPlaceholder = NSAttributedString(string: "Phone", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        phoneField.setTintColor(.darkGray)
        
        phoneField.setBackgroundColor()
        
        phoneField.setLeftPaddingPoints(5)
        
        phoneField.setRightPaddingPoints(5)
        
        //Email Field
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        emailField.setTintColor(.darkGray)
        
        emailField.setBackgroundColor()
        
        emailField.setLeftPaddingPoints(5)
        
        emailField.setRightPaddingPoints(5)
        
        //Save Address Button
        saveAddressButton.layer.cornerRadius = saveAddressButton.frame.height / 2
        
       //TapView added to the map view
        billingMap.addSubview(mapTapView)
    }
    
    @objc private func showMapView(){
        delegate?.presentedMapView(self,"Billing")
    }
    
    @IBAction func saveAddressPtrressed(_ sender: Any) {
        if firstNameField.text!.isEmpty{
            delegate?.presentedErrorMessage("Enter your first name")
        } else if lastNameField.text!.isEmpty{
            delegate?.presentedErrorMessage("Enter your last name")
        } else if houseNoField.text!.isEmpty{
            delegate?.presentedErrorMessage("Enter your house no and street name")
        } else if townNameField.text!.isEmpty {
            delegate?.presentedErrorMessage("Enter your town or city")
        } else if postalCodeField.text!.isEmpty{
            delegate?.presentedErrorMessage("Enter your postcode or zip")
        } else if phoneField.text!.isEmpty {
            delegate?.presentedErrorMessage("Enter your valid phone number")
        } else if emailField.text!.isEmpty {
            delegate?.presentedErrorMessage("Enter your valid email address")
        } else {
            print("Successfully Added")
        }
    }
}

extension BillingAddressViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension BillingAddressViewController : CustomLocationDelegate {
    
    func getBillingLocation() {
        print("get Billing Location...!")
    }
}
