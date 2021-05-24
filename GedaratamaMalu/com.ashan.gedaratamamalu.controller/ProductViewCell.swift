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
            
            self.productImage.image = UIImage(named: "Fish 1")
            if let categoryName = productDetails.category!.name{
                self.catagoryNameLabel.text = categoryName
            }
            self.productNameLabel.text = productDetails.name!
            self.prouuctPrice.text = "\(String(productDetails.unitprice!).convertDoubleToCurrency()) per kg"
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
