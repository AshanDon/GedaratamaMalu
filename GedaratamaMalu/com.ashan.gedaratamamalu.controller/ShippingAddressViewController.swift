//
//  ShippingAddressViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/24/21.
//

import UIKit
import MapKit

class ShippingAddressViewController: UIViewController {

    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var houseNoField: UITextField!
    @IBOutlet weak var apartmentNoField: UITextField!
    @IBOutlet weak var shippingMapView: MKMapView!
    @IBOutlet weak var townField: UITextField!
    @IBOutlet weak var postalField: UITextField!
    @IBOutlet weak var saveAddress: UIButton!
    
    var delegate : MapDelegate?
    
    private lazy var mapTapView : UIView = {
        let mView = UIView()
        mView.isUserInteractionEnabled = true
        mView.frame = shippingMapView.bounds
        mView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapViewTap)))
        return mView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameField.delegate = self
        lastNameField.delegate = self
        houseNoField.delegate = self
        apartmentNoField.delegate = self
        townField.delegate = self
        postalField.delegate = self
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeViewComponent()
    }
    
    private func changeViewComponent(){
        
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
        apartmentNoField.attributedPlaceholder = NSAttributedString(string: "Apartment, suite, unit etc. (optional)", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        apartmentNoField.setTintColor(.darkGray)
        
        apartmentNoField.setBackgroundColor()
        
        apartmentNoField.setLeftPaddingPoints(5)
        
        apartmentNoField.setRightPaddingPoints(5)
        
        //Town Field
        townField.attributedPlaceholder = NSAttributedString(string: "Town/City", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        townField.setTintColor(.darkGray)
        
        townField.setBackgroundColor()
        
        townField.setLeftPaddingPoints(5)
        
        townField.setRightPaddingPoints(5)
        
        //Postal Code Field
        postalField.attributedPlaceholder = NSAttributedString(string: "Postcode / Zip", attributes: [
            
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)
            
        ])
        
        postalField.setTintColor(.darkGray)
        
        postalField.setBackgroundColor()
        
        postalField.setLeftPaddingPoints(5)
        
        postalField.setRightPaddingPoints(5)
        
        //Save Address Button
        saveAddress.layer.cornerRadius = saveAddress.frame.height / 2
        
        //Added to the mapTapView in ShippingMapView
        shippingMapView.addSubview(mapTapView)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if firstNameField.text!.isEmpty{
            delegate?.presentedErrorMessage("Enter your first name")
        } else if lastNameField.text!.isEmpty{
            delegate?.presentedErrorMessage("Enter your last name")
        } else if houseNoField.text!.isEmpty{
            delegate?.presentedErrorMessage("Enter your house no and street name")
        } else if townField.text!.isEmpty {
            delegate?.presentedErrorMessage("Enter your town or city")
        } else if postalField.text!.isEmpty{
            delegate?.presentedErrorMessage("Enter your postcode or zip")
        } else {
            print("Done..")
        }
    }
    
    @objc private func mapViewTap(){
        delegate?.presentedMapView(self, "Shipping")
    }
}

extension ShippingAddressViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension ShippingAddressViewController : CustomLocationDelegate {
    
    func getShippingLocation() {
        print("get Shipping Location...!")
    }
}
