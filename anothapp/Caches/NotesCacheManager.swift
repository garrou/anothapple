//
//  NotesCacheManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 29/08/2025.
//

import Foundation

class NotesCacheManager {
    
    static let shared = NotesCacheManager()
    private let cache = NSCache<NSString, Note>()
    private var keys: Set<Int> = []
    private let searchService = SearchService()
    
    private func store(id: Int, value: Note) {
        cache.setObject(value, forKey: String(id) as NSString)
        keys.insert(id)
    }
    
    private func remove(id: Int) {
        cache.removeObject(forKey: String(id) as NSString)
        keys.remove(id)
    }
    
    private func loadNotes() async -> [Note] {
        do {
            let fetched = try await searchService.fetchNotes()
            fetched.forEach { store(id: $0.id, value: $0) }
            return fetched
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la récupération des notes")
            return []
        }
    }
    
    private func getAll() -> [Note] {
        keys.compactMap { id in getById(id: id) }
    }
    
    func clear() {
        cache.removeAllObjects()
        keys.removeAll()
    }
    
    func getById(id: Int) -> Note? {
        cache.object(forKey: String(id) as NSString)
    }
    
    func getNotes() async -> [Note] {
        var notes = getAll()
        if notes.isEmpty { notes = await loadNotes() }
        return notes.sorted { $0.id < $1.id }
    }
}
