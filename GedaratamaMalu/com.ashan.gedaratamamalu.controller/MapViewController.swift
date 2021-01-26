//
//  MapViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/25/21.
//

import UIKit
import MapKit

@objc protocol CustomLocationDelegate {
    @objc optional func getBillingLocation()
    @objc optional func getShippingLocation()
}
class MapViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLacationButton: UIButton!
    
    public var delegate : CustomLocationDelegate!
    public var addressType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeViewComponent()
    }

    
    private func changeViewComponent(){
        
        //Navigation Bar
        let navigationItem = UINavigationItem()
        navigationItem.title = "Location"
        
        let leftButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelView))
        navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        navigationItem.rightBarButtonItem = rightButton
        
        navigationBar.setItems([navigationItem], animated: false)
    }
    
    @objc private func cancelView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonPressed(){
        switch addressType {
        case "Billing":
            delegate?.getBillingLocation!()
            break
        case "Shipping":
            delegate?.getShippingLocation?()
            break
        default:
            break
        }
    }
}
