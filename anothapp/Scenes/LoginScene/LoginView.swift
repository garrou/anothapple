//
//  LoginPageView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    @FocusState private var isEmailFieldFocused: Bool
    @FocusState private var isPasswordFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.black)
                .padding(.bottom, 10)
            
            Text("Se connecter")
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 10)
            
            TextField("Identifiant", text: $viewModel.identifier)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isEmailFieldFocused ? .black : .gray.opacity(0.5), lineWidth: 1)
                )
                .focused($isEmailFieldFocused)
            
            SecureField("Mot de passe", text: $viewModel.password)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isPasswordFieldFocused ? .black : .gray.opacity(0.5), lineWidth: 1)
                )
                .focused($isPasswordFieldFocused)
            
            Button(action: {
                Task {
                    await viewModel.performLogin()
                }
            }) {
                Text("Se connecter")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(.black)
                    .cornerRadius(8)
            }
            
            HStack {
                Text("Pas de compte ?").font(.system(size: 14))
                Button(action: viewModel.navigateToSignUpPage) {
                    Text("S'inscrire")
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
    LoginView(viewModel: .mock)
}
