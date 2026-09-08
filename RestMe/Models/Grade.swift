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
        let distanceFromGreenZone = abs(cookingProgress - 0.5)

        if distanceFromGreenZone <= GameConfig.greenZoneWidth / 2 {
            return .perfect
        }

        if distanceFromGreenZone <= GameConfig.greenZoneWidth {
            return .good
        }

        return .low
    }
}
