//
//  math.swift
//  BetterBreath
//
//  Created by Valtteri Laine on 12.9.2024.
//

import Foundation

func bezierBlend(t: Double) -> Double {
    return t * t * (3 - 2 * t)
}

func InOutQuadBlend(t: Double) -> Double {
    if t <= 0.5 {
        return 2 * t * t
    }

    let modT = t - 0.5
    return 2 * modT * (1 - modT) + 0.5
}

// Double check is correct
func easeInOut(t: Double) -> Double {
    // This is a simple easeInOut function using a cubic polynomial expression
    return t < 0.5 ? 4 * t * t * t : 1 - pow(-2 * t + 2, 3) / 2
}
