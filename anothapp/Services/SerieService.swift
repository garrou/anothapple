//
//  SerieService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

class SerieService {
    
    private let baseUrl = "\(BaseService.serverUrl)/shows"
    private let decoder: JSONDecoder = JSONDecoder()
    
    func fetchSeries(status: String?) async throws -> [Serie] {
        let url = status == nil ? baseUrl : "\(baseUrl)?status=\(status!)"
        let (data, ok) = try await BaseService.shared.request(url: url)
        return ok ? try decoder.decode([Serie].self, from: data) : []
    }
    
    func fetchSerieInfos(id: Int) async throws -> SerieInfos? {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/\(id)")
        return ok ? try? decoder.decode(SerieInfos.self, from: data) : nil
    }
    
    func changeFavorite(id: Int, request: StatusRequest) async throws -> Bool {
        let (_, ok) = try await BaseService.shared.dataRequest(url: "\(baseUrl)/\(id)", method: "PATCH", data: request)
        return ok
    }
    
    func changeWatching(id: Int, request: StatusRequest) async throws -> Bool {
        let (_, ok) = try await BaseService.shared.dataRequest(url: "\(baseUrl)/\(id)", method: "PATCH", data: request)
        return ok
    }
    
    func deleteSerie(id: Int, fromList: Bool = false) async throws -> Bool {
        let (_, ok) = try await BaseService.shared.request(url: "\(baseUrl)/\(id)?list=\(fromList)", method: "DELETE", successCode: 204)
        return ok
    }
    
    func addSerie(request: SerieRequest) async throws -> (Data, Bool) {
        try await BaseService.shared.dataRequest(url: "\(baseUrl)", method: "POST", data: request, successCode: 201)
    }
    
    func addSeason(request: SeasonRequest) async throws -> Bool {
        let (_, ok) = try await BaseService.shared.dataRequest(url: "\(baseUrl)/\(request.id)/seasons", method: "POST", data: request, successCode: 201)
        return ok
    }
    
    func fetchSeasonInfos(id: Int, num: Int) async throws -> [SeasonInfos] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/\(id)/seasons/\(num)")
        return ok ? try decoder.decode([SeasonInfos].self, from: data) : []
    }
}
