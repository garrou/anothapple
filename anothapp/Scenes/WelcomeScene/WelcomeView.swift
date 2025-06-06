//
//  WelcomeView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import SwiftUI

struct WelcomeView: View {
    
    @StateObject var viewModel: WelcomeViewModel
    
    var body: some View {
        VStack {
            Text("Anothapp")
                .font(.largeTitle)
                .textCase(.uppercase)
            
            GridView(items: viewModel.images, columns: 3) { image in
                ImageCardView(url: image)
            }.frame(maxHeight: .infinity)
            
            Button(action: viewModel.navigateToLoginPage) {
                Text("Se connecter")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 30)
        .task {
            await viewModel.loadImages(limit: 9)
        }
    }
}

#Preview {
    WelcomeView(viewModel: .mock)
}
