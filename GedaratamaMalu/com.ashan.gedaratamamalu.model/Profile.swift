//
//  Profile.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 4/23/21.
//

import Foundation

struct Profile : Codable {
    
    let date : String?
    let email : String?
    let firstName : String?
    let id : Int?
    let lastName : String?
    let mobile : String?
    let password : String?
    let profileType : ProfileType?
    let status : Bool?
    let userName : String?
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case email = "email"
        case firstName = "first_Name"
        case id = "id"
        case lastName = "last_Name"
        case mobile = "mobile"
        case password = "password"
        case profileType = "profileType"
        case status = "status"
        case userName = "userName"
    }
    
    init(id:Int,firstName: String, lastName: String, mobile: String, email: String, userName: String, password: String, status: Bool, date: String, profileType: ProfileType) {
        self.date = date
        self.email = email
        self.firstName = firstName
        self.id = id
        self.lastName = lastName
        self.mobile = mobile
        self.password = password
        self.profileType = profileType
        self.status = status
        self.userName = userName
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        profileType = try ProfileType(from: decoder)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
    }
    
}
