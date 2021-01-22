//
//  CartRowViewCell.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/21/21.
//

import UIKit

class CartRowViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var pulsButton: UIButton!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    var getRowDetail : Product! {
        
        didSet{
            guard let details = getRowDetail else { return }
            
            self.productImageView.image = UIImage(named: details.productImage)
            self.productNameLabel.text = details.productName
            
            self.unitPriceLabel.text =  String(details.productPrice).convertDoubleToCurrency()
            self.qtyLabel.text = "\(details.productQty)"
            self.priceLabel.text = String(details.productPrice * Double(details.productQty)).convertDoubleToCurrency()
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2.5, left: 0, bottom: 2.5, right: 0))
        
        contentView.layer.opacity = Float(70)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
