//
//  GridView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 25/03/2025.
//

import SwiftUI

struct GridView<Item, Content>: View where Item: Hashable, Content: View {
    
    let items: [Item]
    let columns: [GridItem]
    let content: (Item) -> Content
    
    init(items: [Item], columns: Int, @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = items
        self.columns = Array(repeating: GridItem(.flexible()), count: columns)
        self.content = content
    }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(items, id: \.self.hashValue) { item in
                content(item)
            }
        }
    }
}

#Preview {
    GridView(items: Datasource.mockImages, columns: 2) { url in
        ImageCardView(url: url)
    }
}
