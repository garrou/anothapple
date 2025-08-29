//
//  Stat.swift
//  anothapp
//
//  Created by Adrien Garrouste on 27/05/2025.
//

enum ChartGroupedType: String {
    case seasons = "seasons"
    case episodes = "episodes"
    case kinds = "kinds"
    case bestMonths = "best-months"
    case countries = "countries"
    case platforms = "platforms"
    case notes = "notes"
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
