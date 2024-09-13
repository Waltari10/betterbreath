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
            .padding(16) // inner padding
            .background(Color(.white))
            .cornerRadius(12)
            .padding(.vertical, 8) // outer padding
            .padding(.horizontal, 16)
    }
}
