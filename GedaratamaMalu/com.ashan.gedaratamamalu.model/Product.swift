//
//  Product.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/16/21.
//

import Foundation

struct Product : Codable {
    
    let id : Int?
    let name : String?
    let description : String?
    let unitprice : Double?
    var qty : Int?
    let date : String?
    let category : Category?
    let supplier : Supplier?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case description = "description"
        case unitprice = "unitprice"
        case date = "date"
        case category = "category"
        case supplier = "supplier"
        case qty
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        unitprice = try values.decodeIfPresent(Double.self, forKey: .unitprice)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        category = try values.decodeIfPresent(Category.self, forKey: .category)
        supplier = try values.decodeIfPresent(Supplier.self, forKey: .supplier)
        qty = try values.decodeIfPresent(Int.self, forKey: .qty)
    }
    
}
