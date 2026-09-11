//
//  Grade.swift
//  RestMe
//
//  Created by Rahmandhika Putra Purwdi Wicaksono on 05/09/26.
//

enum Grade: Equatable {
    case perfect
    case good
    case low

    static func grade(for cookingProgress: Double) -> Grade {
        if cookingProgress >= GameConfig.perfectZoneStart {
            return .perfect
        }

        return .good
    }
}
