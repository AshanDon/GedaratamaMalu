//
//  Supplier.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 5/9/21.
//

import Foundation

struct Supplier : Codable {
    let id : Int?
    let name : String?
    let address : String?
    let mobile1 : String?
    let mobile2 : String?
    let email : String?
    let date : String?
    let status : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case address = "address"
        case mobile1 = "mobile1"
        case mobile2 = "mobile2"
        case email = "email"
        case date = "date"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        mobile1 = try values.decodeIfPresent(String.self, forKey: .mobile1)
        mobile2 = try values.decodeIfPresent(String.self, forKey: .mobile2)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
    }

}
