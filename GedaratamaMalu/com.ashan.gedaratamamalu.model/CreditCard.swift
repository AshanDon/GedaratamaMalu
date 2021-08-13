//
//  CreditCard.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 6/6/21.
//

import Foundation
import UIKit

struct CreditCard : Codable{
    
    let cardNumber : String?
    let cardTypeImage : String?
    let expiryDate : String?
    let securityCode : String?
    
    init(cardNumber : String,cardTypeImage : String,expiryDate : String,securityCode : String) {
        self.cardNumber = cardNumber
        self.cardTypeImage = cardTypeImage
        self.expiryDate = expiryDate
        self.securityCode = securityCode
    }
}
