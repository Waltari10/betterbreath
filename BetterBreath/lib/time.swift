//
//  time.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 28.7.2024.
//

import Foundation


func formatSeconds(seconds: Double) -> String {
    let minutes = seconds / 60
    let remainingSeconds = seconds.remainder(dividingBy: 60)
    return String(format: "%02d:%02d", Int(minutes), Int(remainingSeconds))
}
