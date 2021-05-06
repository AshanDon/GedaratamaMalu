//
//  AuthenticationViewModel.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 4/23/21.
//

import Foundation
import Alamofire

protocol AuthenticationDelegate {
    
    func getJwtToken(token : String)
    
}

class AuthenticationViewModel {
    //192.168.0.182
    private let baseURL : String = "http://192.168.0.182:8080/malukade/v1"
    
    public var delegate : AuthenticationDelegate!
    
    public func getDefaultJwtWebToken(){
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        

        let auth = Authentication(userName: "AshanDon", password: "ashan123")
        
        AF.request("\(baseURL)/authenticate",method: .post,parameters: auth,encoder: JSONParameterEncoder.default,headers: headers, interceptor: nil,requestModifier: nil).responseDecodable(of: JwtToken.self) { response in
            if let getData = response.value {
                self.delegate.getJwtToken(token: getData.jwt)
            }
        }.resume()
    }
}
