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
    
    fileprivate var productMV : ProductViewModel!
    
    var getRowDetail : Product! {
        
        didSet{
            guard let details = getRowDetail else { return }
            
            self.productMV.getProductImage(ProductCode: details.id!)
            self.productNameLabel.text = details.name!
            self.unitPriceLabel.text =  "\(String(details.unitprice!).convertDoubleToCurrency()) per Kg"
            let qty = details.qty ?? 0
            self.qtyLabel.text = String(qty)
            self.priceLabel.text = String(details.unitprice! * Double(qty)).convertDoubleToCurrency()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2.5, left: 0, bottom: 2.5, right: 0))
        
        contentView.layer.opacity = Float(70)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        productMV = ProductViewModel(UserDefaults.standard.object(forKey: "JWT_TOKEN") as! String)
        productMV.delegate = self
    }
}

extension CartRowViewCell : ProductDelegate {
    func getProductImage(_ imageData: NSData) {
        self.productImageView.image = UIImage(data: imageData as Data)
    }
}
