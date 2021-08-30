//
//  CategoryViewCell.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 8/30/21.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {

    @IBOutlet fileprivate weak var categoryNameLabel: UILabel!
    @IBOutlet fileprivate weak var categoryImageView: UIImageView!
    
    var categoryName : String = String() {
        didSet{
            self.categoryNameLabel.text = categoryName
        }
    }
    
    var categoryImage : String = String() {
        didSet{
            self.categoryImageView.image = UIImage(named: categoryImage)
        }
    }
    
    var cellBackgroundColor : UIColor = UIColor() {
        didSet{
            self.contentView.layer.backgroundColor = cellBackgroundColor.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        createLayout()
    }

    fileprivate func createLayout(){
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = CGFloat(Float(15))
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(named: "White_Color")!.cgColor
        
        self.categoryNameLabel.font = UIFont(name: "LucidaGrande", size: 16)
        self.categoryNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.categoryNameLabel.textColor = UIColor(named: "White_Color")
        
    }
}
