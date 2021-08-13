//
//  PaymentModelView.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 8/12/21.
//

import Foundation
import Alamofire

class PaymentModelView {
    
    fileprivate var jwtToken : String!
    fileprivate let baseURL : String = "http://192.168.0.182:8080/malukade/v1"
    
    var delegate : OrderDelegate!
    
    init(JwtToken token : String) {
        self.jwtToken = token
    }
    
    fileprivate var httpHeaders : HTTPHeaders {
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json"),
            .authorization(bearerToken: jwtToken)
        ]
        return headers
    }
    
    func saveOrderPayment(paymentDetails : [PaymentDetails]) {
        
        var url : String {
            return "\(baseURL)/payment_details"
        }
        
        guard let urlString = URL(string: url) else { return }
        
        var urlRequest : URLRequest!
    
        do {
            urlRequest = try URLRequest(url: urlString, method: .post, headers: httpHeaders)
    
            urlRequest.httpBody = try JSONEncoder().encode(paymentDetails)
            
        } catch let exception {
            print(exception.localizedDescription)
        }
        
        AF.request(urlRequest).responseJSON { [weak self] (response) in
            
            guard let strongeSelf = self else { return }
            
            if let error = response.error {
                print(error.localizedDescription)
            }
            
            if let res = response.response {
                strongeSelf.delegate.showResponseCode(HttpCode: res.statusCode)
            }
        }
    }
}
