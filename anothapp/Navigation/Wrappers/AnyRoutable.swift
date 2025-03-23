//
//  AnyRoutable.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import SwiftUI

struct AnyRoutable: Routable {
    private let base: any Routable
    private let equals: (any Routable) -> Bool

    init<T: Routable>(_ routable: T) {
        base = routable
        equals = { other in
            guard let otherBase = other as? T else { return false }
            return routable == otherBase
        }
    }

    func makeView() -> AnyView {
        self.base.makeView()
    }

    func hash(into hasher: inout Hasher) {
        self.base.hash(into: &hasher)
    }

    static func == (lhs: AnyRoutable, rhs: AnyRoutable) -> Bool {
        lhs.equals(rhs.base)
    }

}
