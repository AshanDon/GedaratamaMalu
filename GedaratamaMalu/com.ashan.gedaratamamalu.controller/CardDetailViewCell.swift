//
//  CardDetailViewCell.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 5/28/21.
//

import UIKit

class CardDetailViewCell: UITableViewCell {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var cartTypeImage: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardExpLabel: UILabel!
    
    public var cardList : CreditCard! {
        didSet{
            guard let details = cardList else { return }
            
            self.cartTypeImage.image = details.cardTypeImage
            self.cardNumberLabel.text = details.cardNumber
            self.cardExpLabel.text = details.expiryDate
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0))
    }
    
    fileprivate func setupLayout(){
        //selectButton
        selectButton.layer.cornerRadius = selectButton.frame.height / 2
        selectButton.layer.borderWidth = CGFloat(2)
        selectButton.layer.borderColor = UIColor(named: "CartRow_Background_Color")!.cgColor
        selectButton.backgroundColor = UIColor(named: "White_Color")
    }
}
