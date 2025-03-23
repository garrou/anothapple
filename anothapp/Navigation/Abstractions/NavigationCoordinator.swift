//
//  NavigationCoordinator.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

protocol NavigationCoordinator {
    func push(_ path: any Routable)
    func popLast()
    func popToRoot()
}
