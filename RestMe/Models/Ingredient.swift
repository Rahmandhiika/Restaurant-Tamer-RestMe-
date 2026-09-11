//
//  Ingredient.swift
//  RestMe
//
//  Created by Rahmandhika Putra Purwdi Wicaksono on 05/09/26.
//

enum Ingredient: String, Hashable {
    case plate
    case bun
    case filling
    case rawMeat
    case doneMeat
}

enum CookingVisual: Equatable {
    case raw
    case done
}

enum AssemblyVisual: Equatable {
    case plate
    case bun
    case filling
    case doneMeat
    case bunIsian
    case bunDoneMeat
    case doneMeatIsian
    case burger

    var foodVerticalOffset: Double {
        switch self {
        case .bunIsian:
            GameConfig.bunIsianVerticalOffset
        case .bunDoneMeat:
            GameConfig.bunDoneMeatVerticalOffset
        case .burger:
            GameConfig.burgerVerticalOffset
        default:
            0
        }
    }
}
