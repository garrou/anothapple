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
                        .frame(height: 120)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .cornerRadius(10)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding()
    }
}

#Preview {
    ImageCardView(imageUrl: "https://picsum.photos/200")
}
