//
//  ProfileView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 21/04/2025.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel: ProfileViewModel
    
    var body: some View {
        ScrollView {
            if let user = viewModel.profile {
                ImageCardView(url: user.picture)
                Text(user.username).font(.headline)
                Text(user.email).font(.caption)
            }
        }.onAppear {
            viewModel.loadProfile()
        }
    }
}
