//
//  FriendCardView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 30/03/2025.
//

import SwiftUI

struct CardView: View {
    
    let picture: String?
    let text: String
    
    var body: some View {
        VStack {
            if picture != nil {
                ImageCardView(url: picture!)
            } else {
                Image(systemName: "photo")
                    .frame(width: 50, height: 50)
            }
            Text(text).font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 1)
    }
}

#Preview {
    CardView(picture: Datasource.mockFriend.picture, text: Datasource.mockFriend.username)
}
