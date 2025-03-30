//
//  ImageCardView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/03/2025.
//

import SwiftUI

struct ImageCardView: View {
    
    let url: String?
    let radius = 10.0
    private let defaultHeight = 200.0
    
    var body: some View {
        VStack {
            if url != nil {
                AsyncImage(url: URL(string: url!)) { phase in
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
                            .frame(height: defaultHeight)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(radius)
        .padding(.all, 1)
    }
}

#Preview {
    ImageCardView(url: Datasource.mockImages[0])
}
