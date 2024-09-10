//
//  User.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 27.7.2024.
//

import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique) var id: String = "0"
    var breathSoundEnabled: Bool = true

    init(id: String = "0", breathSoundEnabled: Bool = true) {
        self.id = id
        self.breathSoundEnabled = breathSoundEnabled
    }
}
