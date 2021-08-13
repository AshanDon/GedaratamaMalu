//
//  ProductViewCell.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/16/21.
//

import UIKit

class ProductViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage :UIImageView!
    @IBOutlet weak var catagoryNameLabel :UILabel!
    @IBOutlet weak var productNameLabel :UILabel!
    @IBOutlet weak var prouuctPrice :UILabel!
    @IBOutlet weak var addCartButton :UIButton!
    
    fileprivate var productVM : ProductViewModel!
    
    //public var delegate : ProductDelegate!
    
    var product : Product! {
        didSet{
            guard let productDetails = product else { return }
            
            setProductImage(productDetails.id!)
            
            if let productImageList = productDetails.productImage{
                for imageInfo in productImageList {
                    print(imageInfo.imageName!)
                    self.productImage.image = UIImage(systemName: imageInfo.imageName!)
                }
                
                
            }
            
            if let categoryName = productDetails.category!.name{
                self.catagoryNameLabel.text = categoryName
            }
            self.productNameLabel.text = productDetails.name!
            self.prouuctPrice.text = "\(String(productDetails.unitprice!).convertDoubleToCurrency()) per kg"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        productVM = ProductViewModel(UserDefaults.standard.object(forKey: "JWT_TOKEN") as! String)
        productVM.delegate = self
        
        updateCellComponent()
        
    }

    
    private func updateCellComponent(){
        
        addCartButton.layer.cornerRadius = addCartButton.frame.height / 2
        
    }
    
    
    fileprivate func setProductImage(_ id : Int){
        productVM.getProductImage(ProductCode: id)
    }
    
}

extension ProductViewCell : ProductDelegate {
    func getProductImage(_ imageData: NSData) {
        self.productImage.image = UIImage(data: imageData as Data)
    }
}
