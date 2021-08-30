//
//  MyCartViewCell.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 8/15/21.
//

import UIKit

class MyCartViewCell: UITableViewCell {

    @IBOutlet weak var orderOtyLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    public var cellDetails : OrderDetails! {
        didSet {
            self.orderOtyLabel.text = "\(cellDetails.qty) Kg"
            self.productNameLabel.text = cellDetails.product.name! 
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
}
