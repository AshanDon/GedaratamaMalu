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
    
    var product : Product! {
        didSet{
            guard let productDetails = product else { return }
            
            self.productImage.image = UIImage(named: productDetails.productImage)
            self.catagoryNameLabel.text = productDetails.catogaryName
            self.productNameLabel.text = productDetails.productName
            self.prouuctPrice.text = "\(String(productDetails.productPrice).convertDoubleToCurrency()) per kg"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateCellComponent()
        
    }

    
    private func updateCellComponent(){
        
        addCartButton.layer.cornerRadius = addCartButton.frame.height / 2
        
    }
    
}
