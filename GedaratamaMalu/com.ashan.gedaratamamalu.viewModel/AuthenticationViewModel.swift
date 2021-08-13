//
//  AuthenticationViewModel.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 4/23/21.
//

import Foundation
import Alamofire

@objc protocol AuthenticationDelegate {
    @objc optional func getSignInError(_ message : String)
    @objc optional func getTokenInfo(_ token : String,_ userName : String,_ password : String)
}

class AuthenticationViewModel {
    //192.168.0.182
    private let baseURL : String = "http://192.168.0.182:8080/malukade/v1"
    
    public var authDelegate : AuthenticationDelegate!
    
    fileprivate func getHttpHeaders() -> HTTPHeaders{
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        return headers
    }
    
//    public func getDefaultJwtWebToken(){
//
//        let auth = Authentication(userName: "AshanDon", password: "ashan123")
//        
//        AF.request("\(baseURL)/authenticate",method: .post,parameters: auth,encoder: JSONParameterEncoder.default,headers: getHttpHeaders(), interceptor: nil,requestModifier: nil).responseDecodable(of: JwtToken.self) { response in
//            if let getData = response.value {
//                self.authDelegate.getJwtToken!(token: getData.jwt)
//            }
//        }.resume()
//    }
    
    public func getUserProfile(_ userName : String, _ password : String){
        
        let auth = Authentication(userName: userName, password: password)
        
        AF.request("\(baseURL)/authenticate",method: .post,parameters: auth,encoder: JSONParameterEncoder.default,headers: getHttpHeaders(), interceptor: nil,requestModifier: nil).responseDecodable(of: JwtToken.self) { [weak self] response in
            
            guard let strongeSelf = self else { return }
            
            if let value = response.value {
                strongeSelf.authDelegate.getTokenInfo?(value.jwt, value.userName,value.password)
            } else {
                strongeSelf.authDelegate.getSignInError!("Invalid user name or password")
            }
            
        }.resume()
        
    }
}
