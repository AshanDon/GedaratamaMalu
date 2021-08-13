//
//  MapViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/25/21.
//

import UIKit
import MapKit

@objc protocol CustomLocationDelegate {
    @objc optional func getBillingLocation(_ coordinate : CLLocationCoordinate2D)
    @objc optional func getShippingLocation()
    @objc optional func setCustomLocation(_ coordinate : CLLocationCoordinate2D)
}
class MapViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLacationButton: UIButton!
    
    fileprivate let myAnnotation : MKPointAnnotation = MKPointAnnotation()
    fileprivate var coordinate : CLLocationCoordinate2D?
    
    var delegate : CustomLocationDelegate!
    var addressType = String()
    
    fileprivate lazy var locationManager : CLLocationManager = {
       let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
       return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapViewTapped(gestureRecognizer:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeViewComponent()
        
        determineCurrentLocation()
    }

    fileprivate func determineCurrentLocation(){
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
    }
    
    fileprivate func changeViewComponent(){
        
        //Navigation Bar
        let navigationItem = UINavigationItem()
        navigationItem.title = "Location"
        
        let leftButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelView))
        navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        navigationItem.rightBarButtonItem = rightButton
        
        navigationBar.setItems([navigationItem], animated: false)
    }
    
    @objc fileprivate func cancelView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func mapViewTapped(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        myAnnotation.coordinate = coordinate
        mapView.addAnnotation(myAnnotation)
    }
    
    @objc fileprivate func doneButtonPressed(){
        switch addressType {
        case "Billing":
            if let getCoordinate = coordinate {
                delegate?.getBillingLocation!(getCoordinate)
                self.dismiss(animated: true, completion: nil)
            }
            break
        case "Shipping":
            delegate?.getShippingLocation?()
            break
        default:
            break
        }
    }
}

//MARK:- CLLocationManagerDelegate
extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation : CLLocation = locations[0] as CLLocation
        
        //stop updating location
        manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        myAnnotation.title = "Billing Location"
        mapView.addAnnotation(myAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

//MARK:- MKMapViewDelegate
extension MapViewController : MKMapViewDelegate {
    
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
        }
    }
}
