//
//  Address.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 6/24/21.
//

import Foundation

struct AddressDetail : Codable {
    let id : Int?
    let addressType : AddressType?
    let profile : Profile?
    let firstName : String?
    let lastName : String?
    let houseNo : String?
    let apartmentNo : String?
    let city : String?
    let postalCode : String?
    let latitude : String?
    let longitude : String?
    let mobile : String?
    let email : String?
    
    init(id : Int,addressType : AddressType,profile : Profile,firstName : String,lastName : String,houseNo : String,apartmentNo : String,city : String,postalCode : String,latitude : String,longitude : String,mobile : String,email : String) {
        self.id = id
        self.profile = profile
        self.addressType = addressType
        self.firstName = firstName
        self.lastName = lastName
        self.houseNo = houseNo
        self.apartmentNo = apartmentNo
        self.city = city
        self.postalCode = postalCode
        self.latitude = latitude
        self.longitude = longitude
        self.mobile = mobile
        self.email = email
    }
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case profile = "profile"
        case addressType = "addressType"
        case firstName = "firstName"
        case lastName = "lastName"
        case houseNo = "houseNo"
        case apartmentNo = "apartmentNo"
        case city = "city"
        case postalCode = "postalCode"
        case latitude = "latitude"
        case longitude = "longitude"
        case mobile = "mobile"
        case email = "email"
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        id = try value.decodeIfPresent(Int.self, forKey: .id)
        profile = try Profile(from: decoder)
        addressType = try AddressType(from: decoder)
        firstName = try value.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try value.decodeIfPresent(String.self, forKey: .lastName)
        houseNo = try value.decodeIfPresent(String.self, forKey: .houseNo)
        apartmentNo = try value.decodeIfPresent(String.self, forKey: .apartmentNo)
        city = try value.decodeIfPresent(String.self, forKey: .city)
        postalCode = try value.decodeIfPresent(String.self, forKey: .postalCode)
        latitude = try value.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try value.decodeIfPresent(String.self, forKey: .longitude)
        mobile = try value.decodeIfPresent(String.self, forKey: .mobile)
        email = try value.decodeIfPresent(String.self, forKey: .email)
    }
}
