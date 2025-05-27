//
//  SeriesPageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation
import SwiftUI

class DiscoverDetailsViewModel: ObservableObject {
    
    @Published var serie: ApiSerie
    @Published var isMenuOpened = false
    @Published var isSerieAdded = false
    @Published var isSerieInList = false
    @Published var isShowModal = false
    @Published var viewedByFriends: [Friend] = []
    @Published var selectedTab: DiscoverDetailsTab = .details
    @Published var similars: [BaseSerie] = []
    @Published var images: [String] = []
    @Published var characters: [Person] = []
    @Published var openActorDetails: Bool = false
    @Published var selectedActor: PersonDetails? = nil
    @Published var tabContentHeight: CGFloat = ContentHeightPreferenceKey.defaultValue
    @Published var showProfilePictureModal: Bool = false
    @Published var selectedProfilePicture: String? = nil
    @Published var openFriendDetails = false
    @Published var friendIdToConsult: String? = nil
    
    private let router: DiscoverDetailsRouter
    
    init(router: DiscoverDetailsRouter, serie: ApiSerie) {
        self.router = router
        self.serie = serie
        self.isSerieAdded = SeriesCacheManager.shared.isAlreadyAdded(id: serie.id)
        self.isSerieInList = SeriesListCacheManager.shared.isAlreadyAdded(id: serie.id)
    }
    
    func routeToDiscoverDetails(id: Int) async {
        if let fetched = await ApiSeriesCacheManager.shared.getSerie(id: id) {
            router.routeToDiscoverDetails(serie: fetched)
        }
    }
    
    func closeActorDetails() {
        selectedActor = nil
        openActorDetails = false
    }
    
    func openProfilePictureModal(image: String) {
        showProfilePictureModal = true
        selectedProfilePicture = image
    }
    
    func closeProfilePictureModal() {
        showProfilePictureModal = false
        selectedProfilePicture = nil
    }
    
    func openFriendDetailsView(userId: String) {
        openFriendDetails = true
        friendIdToConsult = userId
    }
    
    func closeFriendDetails() {
        openFriendDetails = false
        friendIdToConsult = nil
    }
    
    func updateProfilePicture() async {
        if let image = selectedProfilePicture {
            await UserManager.shared.updateProfilePicture(image: image)
        }
    }
    
    func getDashboardView() -> AnyView {
        if let id = friendIdToConsult {
            return router.getDashboardView(userId: id)
        }
        return AnyView(EmptyView())
    }
    
    @MainActor
    func addSerie() async {
        isSerieAdded = await SeriesCacheManager.shared.addSerie(id: serie.id)
    }
    
    @MainActor
    func changeInList() async {
        let changed = isSerieInList
            ? await SeriesListCacheManager.shared.deleteSerie(id: serie.id)
            : await SeriesListCacheManager.shared.addSerie(id: serie.id)
        
        if changed {
            isSerieInList.toggle()
            ToastManager.shared.setToast(message: isSerieInList ? "\(serie.title) ajoutée dans la liste" : "\(serie.title) supprimée de la liste", isError: !changed)
        }
    }
    
    @MainActor
    func getFriendsWhoWatch() async {
        if !viewedByFriends.isEmpty { return }
        viewedByFriends = await FriendsManager.shared.getFriendsWhoWatch(id: serie.id)
    }
    
    @MainActor
    func getSimilarsSeries() async {
        if !similars.isEmpty { return }
        similars = await SearchManager.shared.getSimilars(id: serie.id)
    }
    
    @MainActor
    func getSerieImages() async {
        if !images.isEmpty { return }
        images = await SearchManager.shared.getSerieImages(id: serie.id)
    }
    
    @MainActor
    func getCharacters() async {
        if !characters.isEmpty { return }
        characters = await SearchManager.shared.getCharacters(id: serie.id)
    }
    
    @MainActor
    func getActorDetails(id: Int) async {
        selectedActor = await SearchManager.shared.getActorDetails(id: id)
        openActorDetails = selectedActor != nil
    }
}

// MARK: - DiscoverDetailsViewModel mock for preview

extension DiscoverDetailsViewModel {
    static let mock: DiscoverDetailsViewModel = .init(router: DiscoverDetailsRouter.mock, serie: Datasource.mockDiscoverSerie)
}
