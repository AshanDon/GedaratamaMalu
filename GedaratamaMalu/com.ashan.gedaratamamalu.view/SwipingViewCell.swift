//
//  SwipingViewCell.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 12/29/20.
//

import UIKit

class SwipingViewCell: UICollectionViewCell {
    
    @IBOutlet weak var intraImageView : UIImageView!
    
    @IBOutlet weak var intraTitleLabel : UILabel!
    
    @IBOutlet weak var intraDetailLabel : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            contentView.topAnchor.constraint(equalTo: topAnchor),
            
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }

}
