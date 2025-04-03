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
            if url != nil {
                KFImage.url(URL(string: url!))
                    .fade(duration: 0.25)
                    .placeholder {
                        LoadingView().scaledToFill()
                    }
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(maxWidth: .infinity)
        .background(.secondary)
        .cornerRadius(radius)
        .padding(.all, 1)
    }
}

#Preview {
    ImageCardView(url: Datasource.mockImages[0])
}
