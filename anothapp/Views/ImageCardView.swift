//
//  ImageCardView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/03/2025.
//

import SwiftUI
import Kingfisher

struct ImageCardView: View {
    
    let url: String?
    let radius = 10.0
    private let defaultHeight = 200.0
    
    @State private var progress: Double = 0.0
    
    var body: some View {
        VStack {
            if url != nil && url?.isEmpty == false {
                KFImage.url(URL(string: url!))
                    .fade(duration: 0.25)
                    .placeholder {
                        LoadingView().scaledToFill()
                    }
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.primary.opacity(0.3), radius: 5, x: 0, y: 2)
                    )
                    .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(radius)
        .padding(.all, 1)
    }
}

#Preview {
    ImageCardView(url: nil)
}
