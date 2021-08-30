//
//  OrderDetails.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 7/10/21.
//

import Foundation

struct OrderDetails : Codable {
    let id, discount, qty, unitPrice: Int
    let order: Order
    let product: Product
    
    init(id : Int, discount : Int, qty : Int, unitPrice : Int, order : Order, product : Product) {
        self.id = id
        self.discount = discount
        self.qty = qty
        self.unitPrice = unitPrice
        self.order = order
        self.product = product
    }
}
