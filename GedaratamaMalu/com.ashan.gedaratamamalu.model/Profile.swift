//
//  Profile.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 4/23/21.
//

import Foundation

struct Profile : Codable {
    
    let first_Name : String
    let last_Name : String
    let mobile : String
    let email : String
    let userName : String
    let password : String
    let status : Bool
    let date : Date
    let profileType : ProfileType
    
    init(first_Name : String,last_Name : String,mobile : String, email : String, userName : String, password : String, status : Bool, date : Date, profileType : ProfileType) {
        self.first_Name = first_Name
        self.last_Name =  last_Name
        self.mobile = mobile
        self.email = email
        self.userName = userName
        self.password = password
        self.status = status
        self.date = date
        self.profileType = profileType
    }
}
