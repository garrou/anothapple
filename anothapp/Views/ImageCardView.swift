//
//  ImageCardView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/03/2025.
//

import SwiftUI

struct ImageCardView: View {
    
    let imageUrl: String
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .scaledToFill()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "photo")
                        .frame(height: 200)
                @unknown default:
                    EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}

#Preview {
    ImageCardView(imageUrl: Datasource.mockImages[0])
}
