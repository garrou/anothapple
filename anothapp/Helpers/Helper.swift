//
//  DateFormatter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 04/04/2025.
//

import Foundation

enum FormatterError: Error {
    case decodingFailed(String)
}

class Helper {
    
    static let shared = Helper()
    private let dateFormatter = DateFormatter()
    
    func stringToDate(str: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") throws -> Date {
        dateFormatter.dateFormat = format
        
        if let date = dateFormatter.date(from: str) {
            return date
        } else {
            throw FormatterError.decodingFailed("Date string not valid")
        }
    }
    
    func dateToString(date: Date, style: DateFormatter.Style? = nil) -> String {
        if let style { dateFormatter.dateStyle = style }
        return dateFormatter.string(from: date)
    }
    
    func formatPlural(str: String, num: Int, prefix: Bool = true, showNum: Bool = true) -> String {
        let suffix = num > 1 ? "s" : ""
        
        if (showNum) {
            return prefix ? "\(num) \(str)\(suffix)" : "\(str)\(suffix) \(num)"
        }
        return "\(str)\(suffix)"
    }
    
    func formatMins(_ mins: Int) -> String {
        let days = mins / (24 * 60)
        let hours = (mins % (24 * 60)) / 60
        let minutes = mins % 60
        var str = ""
        
        if days > 0 { str += formatPlural(str: "jour", num: days) + " " }
        if hours > 0 { str += formatPlural(str: "heure", num: hours) + " " }
        if minutes > 0 { str += formatPlural(str: "min", num: minutes) }
        return str.isEmpty ? formatPlural(str: "min", num: mins) : str
    }
    
    func containsString(_ str1: String, _ str2: String) -> Bool {
        str1.lowercased().folding(options: .diacriticInsensitive, locale: .current).contains(str2.lowercased())
    }
    
    func compareStrings(_ str1: String, _ str2: String) -> Bool {
        let s1 = str1.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        let s2 = str2.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        return s1 < s2
    }
    
    func buildUrlWithParams(url: String, params: [Param]) -> String {
        return params.reduce(url) { acc, curr in
            buildUrl(url: acc, query: curr.name, param: curr.value)
        }
    }
    
    private func buildUrl(url: String, query: String, param: Any?) -> String {
        param == nil ? url : url + (url.contains("?") ? "&" : "?") + "\(query)=\(param!)"
    }
}
