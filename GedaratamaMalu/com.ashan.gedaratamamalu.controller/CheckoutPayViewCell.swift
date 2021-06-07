//
//  CheckoutPayViewCell.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 5/27/21.
//

import UIKit

class CheckoutPayViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cardPayButton: UIButton!
    @IBOutlet weak var cashPayButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
        
    }
    
    fileprivate func setupLayout(){
        
        //cardPayButton
        cardPayButton.setBackgroundImage(UIImage(named: "PayType_Icon"), for: .normal)
        
        //cardPayButton
        cashPayButton.setBackgroundImage(UIImage(named: "SelectedPayType_Icon"), for: .normal)
    }
    
    @IBAction func payMethodClicked(_ sender: UIButton) {
        let buttonArray = [cardPayButton,cashPayButton]

            buttonArray.forEach{

                $0?.isSelected = false
                $0?.setBackgroundImage(UIImage(named: "PayType_Icon"), for: .normal)
            }

            sender.isSelected = true
            sender.setBackgroundImage(UIImage(named: "SelectedPayType_Icon"), for: .normal)
    }
}
