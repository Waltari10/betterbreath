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
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.vertical, 8) // outer padding
            .padding(.horizontal, 16)
    }
}
