//
//  PaymentDetails.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 8/12/21.
//

import Foundation

struct PaymentDetails : Codable{
    
    let id: Int
    let order: Order
    let payment: Payment
    let payAmount: Int
    let date: String
    let cardNum, expDate, securityCode: String
    let status: Bool
    
    init(id : Int,order : Order,payment : Payment,payAmount : Int,date : String,creaditCard : CreditCard,status : Bool) {
        self.id = id
        self.order = order
        self.payment = payment
        self.payAmount = payAmount
        self.date = date
        self.cardNum = creaditCard.cardNumber!
        self.expDate = creaditCard.expiryDate!
        self.securityCode = creaditCard.securityCode!
        self.status = status
    }
    
    enum CodingKeys : String,CodingKey {
        case id = "id"
        case order = "order"
        case payment = "payment"
        case payAmount = "pay_Amount"
        case date = "date"
        case cardNum = "cardNum"
        case expDate = "expDate"
        case securityCode = "securityCode"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)!
        order = try Order(from: decoder)
        payment = try Payment(from: decoder)
        payAmount = try values.decode(Int.self, forKey: .payAmount)
        date = try values.decode(String.self, forKey: .date)
        cardNum = try values.decode(String.self, forKey: .cardNum)
        expDate = try values.decode(String.self, forKey: .expDate)
        securityCode = try values.decode(String.self, forKey: .securityCode)
        status = try values.decode(Bool.self, forKey: .status)
    }
}
