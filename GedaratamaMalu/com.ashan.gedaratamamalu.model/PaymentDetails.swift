//
//  PaymentDetails.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 8/12/21.
//

import Foundation

struct PaymentDetails : Codable{
    
    let id: Int!
    let order: Order!
    let payment: Payment!
    let pay_Amount: Int!
    let date: String!
    let cardNum, expDate, securityCode: String!
    let status: Bool!
    
    init(id : Int,order : Order,payment : Payment,payAmount : Int,date : String,creaditCard : CreditCard,status : Bool) {
        self.id = id
        self.order = order
        self.payment = payment
        self.pay_Amount = payAmount
        self.date = date
        self.cardNum = creaditCard.cardNumber!
        self.expDate = creaditCard.expiryDate!
        self.securityCode = creaditCard.securityCode!
        self.status = status
    }
}
