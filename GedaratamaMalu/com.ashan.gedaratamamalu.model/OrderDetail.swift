//
//  OrderDetails.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 7/10/21.
//

import Foundation

struct OrderDetails : Codable {
    let id, discount, qty, unitPrice: Int?
    let order: Order?
    let product: Product?
    
    init(id : Int, discount : Int, qty : Int, unitPrice : Int, order : Order, product : Product) {
        self.id = id
        self.discount = discount
        self.qty = qty
        self.unitPrice = unitPrice
        self.order = order
        self.product = product
    }
    
    enum CodingKeys : String,CodingKey {
        case id = "id"
        case discount = "discount"
        case qty = "qty"
        case unitPrice = "unitPrice"
        case order = "order"
        case product = "product"
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        id = try value.decodeIfPresent(Int.self, forKey: .id)
        discount = try value.decodeIfPresent(Int.self, forKey: .discount)
        qty = try value.decodeIfPresent(Int.self, forKey: .qty)
        unitPrice = try value.decodeIfPresent(Int.self, forKey: .unitPrice)
        order = try Order(from: decoder)
        product = try Product(from: decoder)
    }
}
