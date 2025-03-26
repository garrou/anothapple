//
//  Interceptor.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

class HTTPInterceptor: NSObject, URLSessionDelegate {
    
    static let shared = HTTPInterceptor()
    
    func interceptRequest(_ request: URLRequest) -> URLRequest {
        var modifiedRequest = request
        let user = SecurityHelper.getUser()
        let token = user?.token ?? ""
        modifiedRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        modifiedRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return modifiedRequest
    }
}

