//
//  AddressType.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 6/24/21.
//

import Foundation

struct AddressType : Codable {
    let id : Int?
    let type : String?
    let status : Bool?
    let date : Date?
    
    init(id : Int,type : String,status : Bool,date : Date) {
        self.id = id
        self.type = type
        self.status = status
        self.date = date
    }
    
    enum CodingKeys :String,CodingKey {
        case id = "id"
        case type = "type"
        case status = "status"
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        id = try value.decodeIfPresent(Int.self, forKey: .id)
        type = try value.decodeIfPresent(String.self, forKey: .type)
        status = try value.decodeIfPresent(Bool.self, forKey: .status)
        date = try value.decodeIfPresent(Date.self, forKey: .date)
    }
}
