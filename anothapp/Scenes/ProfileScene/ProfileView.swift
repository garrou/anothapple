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
        List {
            if let user = viewModel.profile {
                CardView(picture: user.picture, text: user.username) {
                    Text(user.email).font(.caption)
                }
            }
            Button(action: { viewModel.openSheet(.picture) }) {
                IconTextView(icon: "photo", text: "Modifier la photo de profil")
            }
            
            Button(action: { viewModel.openSheet(.email) }) {
                IconTextView(icon: "envelope", text: "Modifier l'email")
            }
            
            Button(action: { viewModel.openSheet(.email) }) {
                IconTextView(icon: "lock", text: "Modifier le mot de passe")
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Profil")
        .sheet(isPresented: $viewModel.isSheetOpened, onDismiss: { viewModel.closeSheet() }) {
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: { viewModel.closeSheet() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.primary)
                    }
                }.padding()
                
                switch (viewModel.openSheet) {
                case .picture:
                    ChangeProfilePictureView()
                case .email:
                    ChangeEmailView()
                case .password:
                    ChangePasswordView()
                default:
                    EmptyView()
                }
            }
        }
        .onAppear {
            viewModel.loadProfile()
        }
    }
}

private struct ChangeProfilePictureView: View {
    var body: some View {
        Text("Profile picture")
    }
}

private struct ChangeEmailView: View {
    var body: some View {
        Text("Change email")
    }
}

private struct ChangePasswordView: View {
    var body: some View {
        Text("Change password")
    }
}

private struct IconTextView: View {
    
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            
            Text(text)
                .font(.headline)
                .foregroundColor(.primary)
                .padding()
        }
    }
}
