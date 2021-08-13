//
//  LocationViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 6/16/21.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController {
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var conformButton: UIButton!
    
    fileprivate let myAnnotation : MKPointAnnotation = MKPointAnnotation()
    fileprivate var coordinate : CLLocationCoordinate2D?
    
    public var delegate : CustomLocationDelegate!
    
    fileprivate lazy var cancelButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        button.setTitle(" Back", for: .normal)
        button.setImage(UIImage(named: "Arrow_Icon"), for: .normal)
        button.setTitleColor(UIColor(named: "Black_Color"), for: .normal)
        button.addTarget(self, action: #selector(backButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var locationButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        button.setImage(UIImage(named: "Location_Icon"), for: .normal)
        button.addTarget(self, action: #selector(locationButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var locationManager : CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapKitView.delegate = self
        mapKitView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapViewTapped(gestureRecognizer:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupLocationView()
        
        determineCurrentLocation()
        
        conformButton.isEnabled = false
        
    }

    fileprivate func setupLocationView(){
    
        let navigationItem = UINavigationItem(title: "Select Location")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: locationButton)
        
        navigationBar.setItems([navigationItem], animated: false)
        
        UINavigationBar.appearance().barTintColor = UIColor(named: "White_Color")
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor(named: "TabBar_Tint_Color")!,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21)
        ]
        
        //Bottom View
        bottomView.applyViewShadow(color: UIColor(named: "Custom_Black_Color")!, alpha: 1, x: 0, y: -5, blur: 0, spread: 2)
        
        //Conform Button
        conformButton.layer.cornerRadius = CGFloat(12)
        conformButton.backgroundColor = UIColor(named: "TabBar_Tint_Color")
    }
    
    @objc fileprivate func backButtonDidPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func locationButtonDidPressed(){
        determineCurrentLocation()
    }
    
    fileprivate func determineCurrentLocation(){
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
    }
    
    @objc fileprivate func mapViewTapped(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapKitView)
        let coordinate = mapKitView.convert(touchPoint, toCoordinateFrom: mapKitView)
        myAnnotation.coordinate = coordinate
        mapKitView.addAnnotation(myAnnotation)
    }
    
    @IBAction func conformButtonDidPressed() {
        if let coordinate = coordinate {
            self.dismiss(animated: true) {
                self.delegate.setCustomLocation?(coordinate)
            }
        }
        
    }
    
}

//MARK:- CLLocationManagerDelegate
extension LocationViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation : CLLocation = locations[0] as CLLocation
        
        //stop updating location
        manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapKitView.setRegion(region, animated: true)
        
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        myAnnotation.title = "My Location"
        mapKitView.addAnnotation(myAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

//MARK:- MKMapViewDelegate
extension LocationViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }

        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.isDraggable = true
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let pinImage = UIImage(named: "Location_Icon")
        annotationView!.image = pinImage
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let coordinate = view.annotation?.coordinate {
            self.coordinate = coordinate
            self.conformButton.isEnabled = true
        }
    }
}
