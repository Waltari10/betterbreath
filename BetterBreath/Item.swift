//
//  Item.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 25.7.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
