//
//  SeriesPageView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

struct DiscoverView: View {
    
    @StateObject var viewModel: DiscoverViewModel
    
    var body: some View {
        VStack {
            Text("Discover series")
        }
    }
}

#Preview {
    DiscoverView(viewModel: .mock)
}

