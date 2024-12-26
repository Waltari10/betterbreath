//
//  CardStyleModifier.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 13.9.2024.
//

import Foundation
import SwiftUI

struct CardStyleModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .padding(12) // inner padding
            .background(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white)
            .cornerRadius(12)
            .padding(.vertical, 8) // outer padding
            .padding(.horizontal, 16)
    }
}
