//
//  Order.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 7/9/21.
//

import Foundation

struct Order : Codable {
    let id: Int
    let profile: Profile
    let addressDetails: AddressDetail
    let discount, amount: Int
    let status: Bool
    let date: String
    
    init(id : Int,profile : Profile,addressDetails : AddressDetail,discount : Int, amount : Int, status : Bool, date : String) {
        self.id = id
        self.profile = profile
        self.addressDetails = addressDetails
        self.discount = discount
        self.amount = amount
        self.status = status
        self.date = date
    }
}
