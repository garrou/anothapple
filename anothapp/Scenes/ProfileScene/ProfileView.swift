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
            
            Button(action: { viewModel.openSheet(.password) }) {
                IconTextView(icon: "lock", text: "Modifier le mot de passe")
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Profil")
        .sheet(isPresented: $viewModel.isSheetOpened, onDismiss: { viewModel.closeSheet() }) {
            VStack {
                HStack {
                    Text(viewModel.sheetTitle)
                        .font(.system(size: 20, weight: .bold))
                    
                    Spacer()
                    
                    Button(action: { viewModel.closeSheet() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.primary)
                    }
                }.padding()
                
                Spacer()
                
                switch (viewModel.openSheet) {
                case .picture:
                    ChangeProfilePictureView(viewModel: viewModel)
                case .email:
                    ChangeEmailView(viewModel: viewModel)
                case .password:
                    ChangePasswordView(viewModel: viewModel)
                default:
                    EmptyView()
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            viewModel.loadProfile()
        }
    }
}

private struct ChangeProfilePictureView: View {
    
    @StateObject var viewModel: ProfileViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.series, id: \.id) { serie in
                Button(action: {
                    Task {
                        await viewModel.expandSerie(id: serie.id)
                    }
                }) {
                    VStack {
                        HStack {
                            Text(serie.title).font(.headline)
                            Spacer()
                            Image(systemName: viewModel.isExpanded(id: serie.id) ? "chevron.down" : "chevron.right")
                        }
                        
                        if viewModel.isExpanded(id: serie.id) {
                            GridView(items: viewModel.images, columns: 2) { image in
                                Button(action: {
                                    Task {
                                        await viewModel.updateProfilePicture(image: image)
                                    }
                                })
                                {
                                    ImageCardView(url: image)
                                }
                            }
                        }
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .task {
            await viewModel.loadSeries()
        }
    }
}

private struct ChangeEmailView: View {
    
    @StateObject var viewModel: ProfileViewModel
    @FocusState private var isEmailFieldFocused: Bool
    @FocusState private var isNewEmailFieldFocused: Bool
    
    var body: some View {
        VStack {
            TextField("Email actuel", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isEmailFieldFocused ? .primary : .secondary, lineWidth: 1)
                )
                .keyboardType(.emailAddress)
                .focused($isEmailFieldFocused)
            
            TextField("Nouvel email", text: $viewModel.newEmail)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isEmailFieldFocused ? .primary : .secondary, lineWidth: 1)
                )
                .keyboardType(.emailAddress)
                .focused($isNewEmailFieldFocused)
                .onSubmit {
                    Task {
                        await viewModel.updateEmail()
                    }
                }
            
            Button(action: {
                Task {
                    await viewModel.updateEmail()
                }
            }) {
                Text("Enregistrer")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(viewModel.isInvalidForm ? .secondary : .primary)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(viewModel.isInvalidForm ? .secondary : .primary, lineWidth: 1))
            }.disabled(viewModel.isInvalidForm)
        }
    }
}

private struct ChangePasswordView: View {
    
    @StateObject var viewModel: ProfileViewModel
    @FocusState private var isPasswordFieldFocused: Bool
    @FocusState private var isNewPasswordFieldFocused: Bool
    @FocusState private var isConfirmPasswordFieldFocused: Bool
    
    var body: some View {
        VStack {
            SecureField("Mot de passe actuel", text: $viewModel.currentPassword)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isPasswordFieldFocused ? .primary : .secondary, lineWidth: 1)
                )
                .focused($isPasswordFieldFocused)
            
            SecureField("Nouveau mot de passe", text: $viewModel.newPassword)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isPasswordFieldFocused ? .primary : .secondary, lineWidth: 1)
                )
                .focused($isPasswordFieldFocused)
            
            SecureField("Confirmer le mot de passe", text: $viewModel.confirmPassword)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isConfirmPasswordFieldFocused ? .primary : .secondary, lineWidth: 1)
                )
                .focused($isConfirmPasswordFieldFocused)
                .onSubmit {
                    Task {
                        await viewModel.updatePassword()
                    }
                }
            
            Button(action: {
                Task {
                    await viewModel.updatePassword()
                }
            }) {
                Text("Enregistrer")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(viewModel.isInvalidForm ? .secondary : .primary)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(viewModel.isInvalidForm ? .secondary : .primary, lineWidth: 1))
            }.disabled(viewModel.isInvalidForm)
        }
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
