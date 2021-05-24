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
    @IBOutlet weak var stockQtyLabel: UILabel!
    
    public var getProductDetails : Product!
    public weak var cartDelegate : CartDelegete?
    
    fileprivate var homeController = HomeViewController()
    fileprivate var productVM : ProductViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let productDetails = getProductDetails {
            
            self.productImage.image = UIImage(named: "Fish 1")!
            self.catogaryLabel.text = productDetails.category!.name!
            self.productNameLabel.text = productDetails.name!
            self.descriptionLabel.text = productDetails.description
            self.priceLabel.text = "\(String(productDetails.unitprice!).convertDoubleToCurrency()) per kg"
        }
        let jwt_Token = UserDefaults.standard.object(forKey: "JWT_TOKEN") as! String
        
        productVM = ProductViewModel(jwt_Token)
        productVM.delegate = self
        showStock()
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
    
    @objc fileprivate func cancelButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func qtyChange(_ sender: UIStepper) {
        qtyLabel.text = "Qty \(Int(sender.value))"
    }
    
    
    @IBAction func addCartDidPressed() {
        
        getProductDetails.qty = Int(qtyStepper.value)
        cartDelegate?.addedItemToCart(getProductDetails)
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func showStock(){
        if let product = getProductDetails {
            productVM.getStockByProductId(product.id!)
            
        }
    }
}

extension ProductViewController : ProductDelegate {
    func getProductList(_ productList: [Product]) {
    }
    
    func getAvailableProductStock(_ qty: Int) {
        self.qtyStepper.maximumValue = Double(qty)
        stockQtyLabel.text = "Available stock in \(qty) Kg"
        if qty > 0 {
            addCartButton.isEnabled = true
        } else {
            addCartButton.isEnabled = false
        }
    }
    
    
}
