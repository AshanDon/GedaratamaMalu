//
//  ProductImage.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 6/13/21.
//

import Foundation

struct ProductImage: Codable {
    let id : Int?
    let imageName : String?
    let imageType : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case imageName = "imageName"
        case imageType = "imageType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        imageName = try values.decodeIfPresent(String.self, forKey: .imageName)
        imageType = try values.decodeIfPresent(String.self, forKey: .imageType)
    }
}
