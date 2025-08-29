//
//  DateFormatter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 04/04/2025.
//

import Foundation
import SwiftUI

enum FormatterError: Error {
    case decodingFailed(String)
}

class Helper {
    
    static let shared = Helper()
    static let minPassword = 8
    static let maxPassword = 50
    static let minUsername = 3
    static let maxUsername = 25
    private let dateFormatter = DateFormatter()
    
    
    func isValidUsername(_ username: String) -> Bool {
        username.count >= Helper.minUsername && username.count <= Helper.maxUsername
    }
    
    func isValidPassword(_ password: String) -> Bool {
        password.count >= Helper.minPassword && password.count <= Helper.maxPassword
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count))
        return matches?.first?.url?.scheme == "mailto"
    }
    
    func stringToDate(str: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") throws -> Date {
        dateFormatter.dateFormat = format
        
        if let date = dateFormatter.date(from: str) {
            return date
        } else {
            throw FormatterError.decodingFailed("Date string not valid")
        }
    }
    
    func dateToString(date: Date, style: DateFormatter.Style? = nil, format: String? = nil) -> String {
        if let style { dateFormatter.dateStyle = style }
        if let format { dateFormatter.dateFormat = format }
        return dateFormatter.string(from: date)
    }
    
    func formatPlural(str: String, num: Int, prefix: Bool = true, showNum: Bool = true) -> String {
        let suffix = num > 1 ? "s" : ""
        
        if showNum {
            return prefix ? "\(num) \(str)\(suffix)" : "\(str)\(suffix) \(num)"
        }
        return "\(str)\(suffix)"
    }
    
    func formatMins(_ mins: Int) -> String {
        if mins < 0 { return "0 min" }
        let days = mins / (24 * 60)
        let hours = (mins % (24 * 60)) / 60
        let minutes = mins % 60
        var str = ""
        
        if days > 0 { str += formatPlural(str: "jour", num: days) + " " }
        if hours > 0 { str += formatPlural(str: "heure", num: hours) + " " }
        if minutes > 0 { str += formatPlural(str: "min", num: minutes) }
        return str.isEmpty ? formatPlural(str: "min", num: mins) : str.trimmingCharacters(in: .whitespaces)
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
    
    func noteToColor(_ note: Note) -> Color {
        switch note.id {
            case 1: return .red
            case 2: return .orange
            case 3: return .yellow
            case 4: return .blue
            case 5: return .green
            default : return .clear
        }
    }
    
    private func buildUrl(url: String, query: String, param: Any?) -> String {
        param == nil ? url : url + (url.contains("?") ? "&" : "?") + "\(query)=\(param!)"
    }
}
