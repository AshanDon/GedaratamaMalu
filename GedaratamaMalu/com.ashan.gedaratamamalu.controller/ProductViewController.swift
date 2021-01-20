//
//  ProductViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/18/21.
//

import UIKit

protocol CartDelegete: class {
    func addedItemToCart(_ item : Product)
}

class ProductViewController: UIViewController {

    @IBOutlet weak var navigationBar : UINavigationBar!
    @IBOutlet weak var productImage : UIImageView!
    @IBOutlet weak var catogaryLabel : UILabel!
    @IBOutlet weak var productNameLabel : UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var priceLabel : UILabel!
    @IBOutlet weak var qtyLabel : UILabel!
    @IBOutlet weak var qtyStepper : UIStepper!
    @IBOutlet weak var addCartButton : UIButton!
    
    public var getProductDetails : Product!
    private var homeController = HomeViewController()
    weak var cartDelegate : CartDelegete?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let productDetails = getProductDetails {
            
            self.productImage.image = UIImage(named: productDetails.productImage)!
            self.catogaryLabel.text = productDetails.catogaryName
            self.productNameLabel.text = productDetails.productName
            self.descriptionLabel.text = "Imported"
            self.priceLabel.text = "රු\(productDetails.productPrice) per kg"
            
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateViewComponent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    fileprivate func updateViewComponent(){
        //NavigationBar
        navigationBar.barTintColor = UIColor(named: "White_Color")!
        navigationBar.barStyle = .default
        
        let navigationItem = UINavigationItem()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancelButtonPressed))
        
        navigationBar.setItems([navigationItem], animated: false)
        
        //UIButton
        addCartButton.layer.cornerRadius = addCartButton.frame.height / 2
        
    }
    
    @objc private func cancelButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func qtyChange(_ sender: UIStepper) {
        qtyLabel.text = "Qty \(Int(sender.value))"
    }
    
    
    @IBAction func addCartDidPressed() {
        
        getProductDetails.productQty = Int(qtyStepper.value)
        cartDelegate?.addedItemToCart(getProductDetails)
        self.dismiss(animated: true, completion: nil)
    }
}
