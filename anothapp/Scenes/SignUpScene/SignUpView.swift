//
//  SignUpPageView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 21/03/2025.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject var viewModel: SignUpViewModel
    @FocusState private var isEmailFieldFocused: Bool
    @FocusState private var isIdentifierFieldFocused: Bool
    @FocusState private var isPasswordFieldFocused: Bool
    @FocusState private var isConfirmPasswordFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Créer un compte")
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 10)
            
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isEmailFieldFocused ? .black : .gray.opacity(0.5), lineWidth: 1)
                )
                .keyboardType(.emailAddress)
                .focused($isEmailFieldFocused)
            
            TextField("Nom d'utilisateur", text: $viewModel.username)
                .autocapitalization(.none)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isIdentifierFieldFocused ? .black : .gray.opacity(0.5), lineWidth: 1)
                )
                .focused($isIdentifierFieldFocused)
            
            SecureField("Mot de passe", text: $viewModel.password)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isPasswordFieldFocused ? .black : .gray.opacity(0.5), lineWidth: 1)
                )
                .focused($isPasswordFieldFocused)
            
            SecureField("Confirmer le mot de passe", text: $viewModel.confirmPassword)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isConfirmPasswordFieldFocused ? .black : .gray.opacity(0.5), lineWidth: 1)
                )
                .focused($isConfirmPasswordFieldFocused)
            
            Button(action: {
                Task {
                    await viewModel.performSignUp()
                }
            }) {
                Text("S'inscrire")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(.black)
                    .cornerRadius(8)
            }
            
            HStack {
                Text("Déjà membre ?").font(.system(size: 14))
                Button(action: viewModel.navigateToLoginPage) {
                    Text("Se connecter")
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.blue)
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 40)
        .alert("Erreur", isPresented: $viewModel.hasError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    SignUpView(viewModel: .mock)
}
