//
//  AddressModelView.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 6/24/21.
//

import Foundation
import Alamofire

protocol AddressDelegate {
    func showCustomAlertMessage(HttpCode code : Int)
    func getBillingAddressInfo(BillingAddress details : AddressDetail)
}


class AddressModelView {
    
    fileprivate let baseURL : String = "http://192.168.0.182:8080/malukade/v1"
    fileprivate var jwtToken : String
    
    public var delegate : AddressDelegate!
    
    init(_ jwtToken : String) {
        self.jwtToken = jwtToken
    }
    
    fileprivate var httpHeaders : HTTPHeaders {
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json"),
            .authorization(bearerToken: jwtToken)
        ]
        
        return headers
    }
    
    public func saveAddressInfomation(_ details : AddressDetail){
        
        var url : String {
            return "\(baseURL)/address_details"
        }
        
        guard let stringURL = URL(string: url) else { return }
        
        var urlRequest = URLRequest(url: stringURL)
        
        urlRequest.httpMethod = "POST"
        urlRequest.headers = httpHeaders
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(details)
        } catch let jsonEncoderEX {
            print(jsonEncoderEX.localizedDescription)
        }
        
        AF.request(urlRequest).response { [weak self](response) in
            
            guard let strongeSelf = self else { return }
            
            if let error = response.error {
                print(error)
                strongeSelf.delegate.showCustomAlertMessage(HttpCode: 500)
            }
            
            if let response = response.response {
                strongeSelf.delegate.showCustomAlertMessage(HttpCode: response.statusCode)
            }
        }.resume()
    }
    
    
    public func getBillingAddressInfo(ProfileId id : Int){
        
        var url : String {
            return "\(baseURL)/address_details/billing/\(id)"
        }
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.queryString,
                   headers: httpHeaders).responseJSON(completionHandler: { [weak self] (response) in
                    guard let strongeSelf = self else { return }
                    
                    if let getError = response.error {
                        print(getError)
                        strongeSelf.delegate.showCustomAlertMessage(HttpCode: 500)
                    }
                    
                    guard let getData = response.data else { return }
                    
                    do{
                        let details = try JSONDecoder().decode(AddressDetail.self, from: getData)
                        strongeSelf.delegate.getBillingAddressInfo(BillingAddress: details)
                    } catch let decodeExp {
                        print(decodeExp.localizedDescription)
                    }
                   })
    }
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
