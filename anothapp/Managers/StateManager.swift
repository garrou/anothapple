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
        _ = await SeriesCacheManager.shared.getSeries()
        _ = await SeriesListCacheManager.shared.getWatchList()
        _ = await PlatformsCacheManager.shared.getPlatforms()
        _ = await KindsCacheManager.shared.getKinds()
        _ = await NotesCacheManager.shared.getNotes()
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
