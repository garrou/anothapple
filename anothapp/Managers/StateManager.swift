//
//  StateManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 05/04/2025.
//

import Foundation

class StateManager: ObservableObject {
    
    static let shared = StateManager()
    @Published var hasLoaded = false
    
    func loadCaches() async {
        guard !hasLoaded else { return }
        async let series = SeriesCacheManager.shared.getSeries()
        async let list = SeriesListCacheManager.shared.getWatchList()
        async let platforms = PlatformsCacheManager.shared.getPlatforms()
        async let kinds = KindsCacheManager.shared.getKinds()
        async let notes = NotesCacheManager.shared.getNotes()
        _ = await (series, list, platforms, kinds, notes)
        hasLoaded = true
    }
    
    func clearCaches() {
        SeriesCacheManager.shared.clear()
        SeriesListCacheManager.shared.clear()
        PlatformsCacheManager.shared.clear()
        KindsCacheManager.shared.clear()
        NotesCacheManager.shared.clear()
        hasLoaded = false
    }
}
