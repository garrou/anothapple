//
//  ContentHeightPreferenceKey.swift
//  anothapp
//
//  Created by Adrien Garrouste on 30/03/2025.
//

import SwiftUI

struct ContentHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 200
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
