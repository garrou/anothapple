//
//  Loading.swift
//  anothapp
//
//  Created by Adrien Garrouste on 30/03/2025.
//

import SwiftUI

struct LoadingView: View {
    
    
    
    var body: some View {
        
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .black))
            .scaleEffect(1.5)
    }
}

#Preview {
    LoadingView()
}
