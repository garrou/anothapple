//
//  StatService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 11/04/2025.
//

import Foundation

enum ChartGroupedType: String {
    case seasons = "seasons"
    case episodes = "episodes"
    case kinds = "kinds"
    case bestMonths = "best-months"
    case countries = "countries"
    case platforms = "platforms"
}

enum ChartGroupedPeriod: String {
    case years = "years"
    case year = "year"
    case months = "months"
}

enum ChartTimeType: String {
    case total = "total"
    case years = "years"
    case month = "month"
    case rank = "rank"
}

enum ChartCountType: String {
    case shows = "shows"
    case episodes = "episodes"
    case seasons = "seasons"
}

class StatService {
    
    private let baseUrl = "\(BaseService.serverUrl)/stats"
    private let decoder: JSONDecoder = JSONDecoder()
    
    func getUserStats(userId: String? = nil) async throws -> UserStat? {
        let url = userId == nil ? baseUrl : "\(baseUrl)?id=\(userId!)"
        let (data, ok) = try await BaseService.shared.request(url: url)
        return ok ? try decoder.decode(UserStat.self, from: data) : nil
    }
    
    func getGroupedCountByTypeByPeriod(type: ChartGroupedType, period: ChartGroupedPeriod? = nil, userId: String? = nil, limit: Int? = nil) async throws -> [Stat] {
        let url = Helper.shared.buildUrlWithParams(url: "\(baseUrl)/grouped-count", params: [
            Param(name: "type", value: type.rawValue),
            Param(name: "period", value: period?.rawValue),
            Param(name: "id", value: userId),
            Param(name: "limit", value: limit)
        ]);
        let (data, ok) = try await BaseService.shared.request(url: url)
        return ok ? try decoder.decode([Stat].self, from: data) : []
    }

    func getTimeByType(type: ChartTimeType, userId: String? = nil) async throws -> [Stat] {
        let url = Helper.shared.buildUrlWithParams(url: "\(baseUrl)/time", params: [
            Param(name: "type", value: type),
            Param(name: "id", value: userId)
        ]);
        let (data, ok) = try await BaseService.shared.request(url: url)
        return ok ? try decoder.decode([Stat].self, from: data) : []
    }
}
