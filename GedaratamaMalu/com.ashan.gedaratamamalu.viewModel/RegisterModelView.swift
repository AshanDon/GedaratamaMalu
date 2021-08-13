//
//  RegisterModelView.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 4/23/21.
//

import Foundation
import Alamofire

protocol RegistrationDelegate {
    func getResponse(_ response : ApiResponse)
    func getUniqueFieldResult(_ field : String ,_ result : Bool)
    func getProfileInfo(_ profile : Profile?)
    
}

class RegisterModelView{
    
    private let token : String
    private let baseURL : String = "http://192.168.0.182:8080/malukade/v1"
    
    public var delegate : RegistrationDelegate!
    
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
    
    public func createNewProfile(_ profile : Profile){
        
        let stringUrl = URL(string: "\(baseURL)/profile")
        var request = URLRequest(url: stringUrl!)
        
        request.httpMethod = "POST"
        request.headers = getHTTPHeaders()
        
        do{
            request.httpBody = try JSONEncoder().encode(profile)
        } catch let encoderException {
            print(encoderException.localizedDescription)
        }
        
        AF.request(request).responseJSON { (response) in
            
            if let getError = response.error{
                print(getError)
            }
            
            guard let data = response.data else { return }
            
            do{
                let responseDetails = try JSONDecoder().decode(ApiResponse.self, from: data)
                self.delegate.getResponse(responseDetails)
            } catch let decoderException {
                print(decoderException.localizedDescription )
            }
        }
    }
    
    public func checkEmail(_ email : String){
        
        let param : Parameters = [
            "email" : email
        ]
        
        AF.request("\(baseURL)/profile/register/email",
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.queryString,
                   headers: getHTTPHeaders()).responseJSON { [weak self] (response) in
                    
                    guard let strongeSelf = self else { return }
                    
                    if let getError = response.error {
                        print(getError)
                    }
                    
                    guard let data = response.data else { return }
                    
                    do{
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Bool] {
                            if let result = json["Result"]{
                                strongeSelf.delegate.getUniqueFieldResult("email",result)
                            }
                        }
                    }catch let exception as NSError{
                        print("Faid to load : \(exception.localizedDescription)")
                    }
                   }
    }
    
    
    public func checkUserName(_ userName : String){
        
        let param : Parameters = [
            "userName" : userName
        ]
        
        AF.request("\(baseURL)/profile/register/user_name",
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.queryString,
                   headers: getHTTPHeaders()).responseJSON { [weak self] (response) in
                        
                    guard let strongeSelf = self else { return }
                    
                    if let getError = response.error{
                        print(getError)
                    }
                    
                    guard let data = response.data else { return }
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Bool] {
                            if let result = json["Result"]{
                                strongeSelf.delegate.getUniqueFieldResult("user_name", result)
                            }
                        }
                    } catch let exception as NSError {
                        print("faild to load : \(exception.localizedDescription)")
                    }
                   }
    }
    
    
    public func getProfileInfoByUserName(UserName name : String){
        
        var url : String {
            return "\(baseURL)/profile/user_Name/\(name)"
        }
        
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.queryString,
                   headers: getHTTPHeaders()).responseJSON { [weak self] (response) in
                    guard let strongeSelf = self else { return }
                    
                    if let getError = response.error {
                        print(print(getError.localizedDescription))
                    }
                    
                    guard let data = response.data else { return }
                    
                    do{
                        let responseDetails = try JSONDecoder().decode(Profile.self, from: data)
                        strongeSelf.delegate.getProfileInfo(responseDetails)
                    } catch let decoderException {
                        print(decoderException.localizedDescription )
                    }
                   }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
