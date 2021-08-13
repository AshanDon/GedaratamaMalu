//
//  OrderDetails.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 7/10/21.
//

import Foundation

struct OrderDetail : Codable {
    var id : Int?
    var discount : Double?
    var qty : Double?
    var unitPrice : Double?
    var order : Order?
    var product : Product?
    
    init(id : Int, discount : Double, qty : Double, unitPrice : Double, order : Order, product : Product) {
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
        discount = try value.decodeIfPresent(Double.self, forKey: .discount)
        qty = try value.decodeIfPresent(Double.self, forKey: .qty)
        unitPrice = try value.decodeIfPresent(Double.self, forKey: .unitPrice)
        order = try Order(from: decoder)
        product = try Product(from: decoder)
    }
}
