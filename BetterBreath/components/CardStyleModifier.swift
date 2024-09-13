//
//  CardStyleModifier.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 13.9.2024.
//

import Foundation
import SwiftUI

struct CardStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16) // Inner padding
            .background(Color(.white)) // Background color
            .cornerRadius(12) // Corner radius
            .padding(.vertical, 8) // Outer vertical padding
            .padding(.horizontal, 16) // Outer horizontal padding
    }
}
