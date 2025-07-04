//
//  ProfileViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 21/04/2025.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    private let router: ProfileRouter
    @Published var profile: User? = nil
    @Published var openSheet: ProfileEnum? = nil
    @Published var isSheetOpened: Bool = false
    @Published var email = ""
    @Published var newEmail = ""
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmPassword = ""
    @Published var series: [Serie] = []
    @Published var images: [Int:[String]] = [:]
    @Published var isLoading = false
    @Published var titleSearch = ""
    
    init(router: ProfileRouter) {
        self.router = router
    }
    
    var sheetTitle: String {
        switch openSheet {
        case .email:
            return "Modifier votre adresse email"
        case .password:
            return "Modifier votre mot de passe"
        case .picture:
            return "Modifier votre photo de profil"
        default:
            return ""
        }
    }
    
    var isInvalidForm: Bool {
        openSheet == .email && (email.isEmpty || newEmail.isEmpty || !Helper.shared.isValidEmail(newEmail))
        || openSheet == .password && (currentPassword.isEmpty || !Helper.shared.isValidPassword(newPassword) || newPassword != confirmPassword)
    }
    
    func openSheet(_ sheet: ProfileEnum) {
        openSheet = sheet
        isSheetOpened = true
    }
    
    func closeSheet() {
        isSheetOpened = false
        openSheet = nil
    }
    
    func clearFields() {
        email = ""
        newEmail = ""
        currentPassword = ""
        newPassword = ""
        confirmPassword = ""
    }
    
    func getSerieImages(id: Int) -> [String] {
        images[id] ?? []
    }
    
    @MainActor
    func loadSerieImages(id: Int) async {
        if let images = images[id] {
            if !images.isEmpty { return }
        }
        isLoading = true
        images[id] = await SearchManager.shared.getSerieImages(id: id)
        isLoading = false
    }
    
    @MainActor
    func updateEmail() async {
        var updated = false
        
        if openSheet == .email {
            updated = await UserManager.shared.updateEmail(email: email, newEmail: newEmail)
        }
        if updated {
            loadProfile()
            clearFields()
        }
        closeSheet()
    }
    
    @MainActor
    func updatePassword() async {
        var updated = false
        
        if openSheet == .password {
            updated = await UserManager.shared.updatePassword(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword)
        }
        closeSheet()
        
        if updated {
            clearFields()
        }
    }
    
    @MainActor
    func updateProfilePicture(image: String) async {
        var updated = false
        
        if openSheet == .picture {
            updated = await UserManager.shared.updateProfilePicture(image: image)
        }
        if updated {
            loadProfile()
            clearFields()
        }
        closeSheet()
    }
    
    @MainActor
    func loadSeries() async {
        series = await SeriesCacheManager.shared.getSeries(title: titleSearch)
    }
    
    func loadProfile() {
        if let user = SecurityManager.shared.getUser() {
            profile = user
        }
    }
}
