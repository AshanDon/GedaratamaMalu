//
//  MenuViewCell.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/23/21.
//

import UIKit

class MenuViewCell: UITableViewCell {
    
    @IBOutlet weak var menuItemLabel : UILabel!
    
    var setItemName : String! {
        didSet{
            guard let itemName = setItemName else { return }
            self.menuItemLabel.text = itemName
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
        
    }
}
