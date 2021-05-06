//
//  Response.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 4/24/21.
//

import Foundation

struct ApiResponse : Decodable {
    
    let times_Stamp : String?
    let status : String?
    let message : String?
    let details : String?

    enum CodingKeys: String, CodingKey {

        case times_Stamp = "times_Stamp"
        case status = "status"
        case message = "message"
        case details = "details"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        times_Stamp = try values.decodeIfPresent(String.self, forKey: .times_Stamp)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        details = try values.decodeIfPresent(String.self, forKey: .details)
    }

}
