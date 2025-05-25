//
//  CardView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 30/03/2025.
//

import SwiftUI

struct CardView<Content: View>: View {
    
    let picture: String?
    let text: String
    let content: (() -> Content)?
    
    var body: some View {
        VStack {
            if picture != nil {
                ImageCardView(url: picture!)
            } else {
                Image(systemName: "photo")
                    .frame(width: 50, height: 50)
            }
            Text(text).font(.headline)
            
            if let content = content {
                content()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 1)
    }
}

extension CardView {
    init(picture: String?, text: String) where Content == EmptyView {
        self.picture = picture
        self.text = text
        self.content = nil
    }
    
    init(picture: String?, text: String, @ViewBuilder content: @escaping () -> Content) {
        self.picture = picture
        self.text = text
        self.content = content
    }
}

#Preview {
    CardView(picture: Datasource.mockFriend.picture, text: Datasource.mockFriend.username)
}
