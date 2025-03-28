//
//  BaseService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 29/03/2025.
//

import Foundation

class BaseService {
    
    static let shared = BaseService()
    private let session = URLSession(configuration: URLSessionConfiguration.default, delegate: HTTPInterceptor.shared, delegateQueue: nil)
    
    func request(url: String, method: String = "GET", successCode: Int = 200) async throws -> (Data, Bool) {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        var request = HTTPInterceptor.shared.interceptRequest(URLRequest(url: url))
        request.httpMethod = method
        let (data, response) = try await session.data(for: request)
        let ok = (response as? HTTPURLResponse)?.statusCode == successCode
        return (data, ok)
    }
    
    func updateRequest<T: Encodable>(url: String, method: String, data: T, successCode: Int = 200) async throws -> Bool {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        var request = HTTPInterceptor.shared.interceptRequest(URLRequest(url: url))
        request.httpMethod = method
        request.httpBody = try JSONEncoder().encode(data)
        let (_, response) = try await session.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == successCode
    }
}
