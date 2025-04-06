//
//  StateManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 05/04/2025.
//

class StateManager {
    
    static let shared = StateManager()
    private var hasLoaded: Bool = false
    
    func loadCaches() async {
        guard !hasLoaded else { return }
        let _ = await SeriesCacheManager.shared.getSeries()
        let _ = await SeriesListCacheManager.shared.getWatchList()
        let _ = await PlatformsCacheManager.shared.getPlatforms()
        hasLoaded = true
    }
}
