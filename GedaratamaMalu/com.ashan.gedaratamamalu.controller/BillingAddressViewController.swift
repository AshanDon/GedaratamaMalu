//
//  BillingAddressViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/24/21.
//

import UIKit
import MapKit
import CoreLocation

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
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var myAnnotation : MKPointAnnotation = MKPointAnnotation()
    
    var selectedCoordinate : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameField.isEnabled = false
        lastNameField.isEnabled = false
        phoneField.isEnabled = false
        emailField.isEnabled = false
        
        houseNoField.delegate = self
        apartmentNo.delegate = self
        townNameField.delegate = self
        postalCodeField.delegate = self
        
        
        // Billing Map 
        billingMap.delegate = self
        billingMap.target(forAction: #selector(showMapView), withSender: nil)
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeViewComponent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //setup cllocation Manager
        determineCurrentLocation()
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
        
//       //TapView added to the map view
//        billingMap.addSubview(mapTapView)
        billingMap.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMapView)))
    }
    
    @objc private func showMapView(){
        delegate?.presentedMapView(self,"Billing")
    }
    
    public func clearFields(){
        houseNoField.text = nil
        apartmentNo.text = nil
        townNameField.text = nil
        postalCodeField.text = nil
        billingMap.removeAnnotations(billingMap.annotations)
    }
    
    fileprivate func determineCurrentLocation(){
        //locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAutherization()
        }
    }
    
    fileprivate func checkLocationAutherization(){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            print("restricted")
            break
        case .denied:
            showLocationErrorAlert(Title: "Location Services Disabled", Message: "Please enable location services for this app.")
            break
        case .authorizedAlways:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            billingMap.showsUserLocation = true
            centerViewOnUserLocation()
            break
        default:
            break
        }
    }
    
    fileprivate func centerViewOnUserLocation(){
        if let location =  locationManager.location?.coordinate{
            let coordinateRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            billingMap.setRegion(coordinateRegion, animated: true)
        }
    }
    
    fileprivate func showLocationErrorAlert(Title title : String,Message message : String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsButton = UIAlertAction(title: "Settings", style: .default) { (settingsAcction) in
            if let bundleId = Bundle.main.bundleIdentifier,
               let url = URL(string: "\(UIApplication.openSettingsURLString)&path=PRIVACY/LOCATION/\(bundleId)") {
                print(url)
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(settingsButton)
        alertController.addAction(cancelAction)
        
        OperationQueue.main.addOperation {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

//MARK:- UITextFieldDelegate
extension BillingAddressViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.text!.isEmpty{
            textField.rightView = nil
        }
        textField.endEditing(true)
        return true
    }
}

//MARK:- MKMapViewDelegate
extension BillingAddressViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
            
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let pinImage = UIImage(named: "Location_Icon")
        annotationView!.image = pinImage
        return annotationView
    }
}


extension BillingAddressViewController : CustomLocationDelegate {
    
    func getBillingLocation(_ coordinate : CLLocationCoordinate2D) {
        print(coordinate.latitude,coordinate.longitude)
        
        billingMap.showsUserLocation = false
    
        myAnnotation.coordinate = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
        
        billingMap.addAnnotation(myAnnotation)
        
        self.selectedCoordinate = coordinate
        
    }
}
