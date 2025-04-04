//
//  Toast.swift
//  anothapp
//
//  Created by Adrien Garrouste on 01/04/2025.
//

import SwiftUI

struct Toast: ViewModifier {
    let message: String
    @Binding var isShowing: Bool
    let isError: Bool
    let duration: TimeInterval
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isShowing {
                VStack {
                    Spacer()
                    HStack {
                        Text(message)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(isError ? Color.red : Color.green)
                            .cornerRadius(8)
                    }
                    .padding(.bottom, 30)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                self.isShowing = false
                            }
                        }
                    }.padding()
                }
            }
        }
    }
}

extension View {
    func toast(message: String, isShowing: Binding<Bool>, isError: Bool, duration: TimeInterval = 3) -> some View {
        self.modifier(Toast(message: message, isShowing: isShowing, isError: isError, duration: duration))
    }
}
