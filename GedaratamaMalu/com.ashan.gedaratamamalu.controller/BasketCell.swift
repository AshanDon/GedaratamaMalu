//
//  BasketCell.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 5/23/21.
//

import UIKit

class BasketCell: UITableViewCell {
    
    @IBOutlet weak var productNameLabel : UILabel!
    @IBOutlet weak var productImageView : UIImageView!
    @IBOutlet weak var categoryNameLabel : UILabel!
    @IBOutlet weak var unitPriceLabel : UILabel!
    @IBOutlet weak var qtyLabel : UILabel!
    
    public var getProduct : Product! {
        didSet{
            guard let product = getProduct else { return }
            
            productNameLabel.text = product.name!
            productImageView.image = UIImage(named: "Fish 1")
            categoryNameLabel.text = product.category!.name!
            unitPriceLabel.text = String(product.unitprice!).convertDoubleToCurrency()
            qtyLabel.text = "Qty \(String(product.qty!))"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2.5, left: 17, bottom: 2.5, right: 17))
    }
}
