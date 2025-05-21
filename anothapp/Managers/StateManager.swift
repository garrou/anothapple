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
        let _ = await SeriesCacheManager.shared.getSeries()
        let _ = await SeriesListCacheManager.shared.getWatchList()
        let _ = await PlatformsCacheManager.shared.getPlatforms()
        let _ = await KindsCacheManager.shared.getKinds()
        hasLoaded = true
    }
    
    func clearCaches() {
        SeriesCacheManager.shared.clear()
        SeriesListCacheManager.shared.clear()
        PlatformsCacheManager.shared.clear()
        KindsCacheManager.shared.clear()
        hasLoaded = false
    }
}
