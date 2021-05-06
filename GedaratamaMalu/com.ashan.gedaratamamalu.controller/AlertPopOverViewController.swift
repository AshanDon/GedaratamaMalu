//
//  AlertPopOverViewController.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 4/29/21.
//

import UIKit

class AlertPopOverViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var getMessage : String?
    var getTextColor : UIColor? = .black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let message = getMessage{
            messageLabel.text = message
        }
        
        if let textColor = getTextColor {
            messageLabel.textColor = textColor
        }
    }
}
