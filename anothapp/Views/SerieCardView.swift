//
//  SerieCardView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 25/03/2025.
//

import SwiftUI

struct SerieCardView: View {
    
    let serie: Serie
    var buttonAction: () -> Void
    
    var body: some View {
        Button(action: buttonAction)
        {
            VStack {
                ImageCardView(imageUrl: serie.poster)
                Text(serie.title).font(.headline).multilineTextAlignment(.center).foregroundColor(.black)
            }
        }
    }
}

#Preview {
    SerieCardView(serie: Datasource.mockSerie, buttonAction: { })
}
