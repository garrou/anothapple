//
//  StateManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 05/04/2025.
//

class StateManager {
    
    static let shared = StateManager()
    var hasLoaded: Bool = false
    
    func loadCaches() async {
        guard !hasLoaded else { return }
        let _ = await SeriesListCacheManager.shared.loadWatchList()
        let _ = await PlatformsCacheManager.shared.loadPlatforms()
        hasLoaded = true
    }
}
