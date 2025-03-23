//
//  WelcomeView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import SwiftUI

struct WelcomePageView: View {
    
    @StateObject var viewModel: WelcomePageViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5)
    ]
    
    var body: some View {
        VStack(spacing: 5) {
            Text("Anothapp")
                .font(.largeTitle)
                .textCase(.uppercase)
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        ImageCardView(imageUrl: image)
                    }
                }
            }
            
            Button(action: viewModel.navigateToLoginPage) {
                Text("Se connecter")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(.black)
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 10)
        .onAppear {
            Task {
                await viewModel.loadImages(limit: 12)
            }
        }
    }
}

#Preview {
    WelcomePageView(viewModel: .mock)
}
