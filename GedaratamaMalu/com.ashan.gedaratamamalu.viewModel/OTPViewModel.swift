//
//  OTPViewModel.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 5/4/21.
//

import Foundation
import Alamofire

protocol OTPDelegate {
    func validateOTPResult(_ result : Bool)
}

class OTPViewModel{
    
    private let token : String
    private let baseURL : String = "http://192.168.0.182:8080/malukade/v1"
    
    public var delegate : OTPDelegate!
    
    public init(_ jwt_Token : String) {
        self.token = jwt_Token
    }
    
    private func getHTTPHeaders() -> HTTPHeaders{
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json"),
            .authorization(bearerToken: token)
        ]
        return headers
    }
    
    public func generateOTP(_ userName : String){
        
        var url : String {
            return "\(baseURL)/OTP/generate/\(userName)"
        }
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.queryString,
                   headers: getHTTPHeaders()).responseJSON {(response) in
                        
                    if let getError = response.error{
                        print(getError.localizedDescription)
                    }
                    
                    if let getValue = response.value {
                        print(getValue)
                    }
                   }
    }
    
    public func validateOTP(_ userName : String, _ otp : String){
        
        let param : Parameters = [
            "userName" : userName,
            "code" : otp
        ]
        
        var url : String {
            return "\(baseURL)/OTP/validate"
        }
        
        AF.request(url,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.queryString,
                   headers: getHTTPHeaders()).responseJSON { [weak self] (response) in
                    
                    guard let strongeSelf = self else { return }
                    
                    if let getError = response.error {
                        print(getError.localizedDescription)
                    }
                    
                    guard let getData = response.data else { return }
                    
                    do{
                        let result = try JSONSerialization.jsonObject(with: getData, options: []) as! [String:Bool]
                        if let isValid = result["Valid"]{
                            strongeSelf.delegate.validateOTPResult(isValid)
                        }
                    } catch let serializationEx {
                        print(serializationEx.localizedDescription)
                    }
                   }
    }
}
