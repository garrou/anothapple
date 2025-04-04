//
//  ErrorsManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import Foundation

class ToastManager: ObservableObject {
    
    static var shared = ToastManager()
    
    @Published var message = ""
    @Published var isError = false
    @Published var showToast = false
    
    func setToast(message: String, isError: Bool = true) {
        DispatchQueue.main.async {
            self.message = message
            self.isError = isError
            self.showToast = true
        }
    }
}
