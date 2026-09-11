//
//  GameConfig.swift
//  RestMe
//
//  Created by Rahmandhika Putra Purwdi Wicaksono on 05/09/26.
//

import Foundation
import CoreGraphics

enum GameConfig {
    static let sceneSize = CGSize(width: 1194, height: 834)
    static let ingredientNodeSize = CGSize(width: 150, height: 150)
    static let serveArea = CGRect(x: 835, y: 210, width: 150, height: 150)
    static let panPosition = CGPoint(x: 518, y: 320)
    static let trashCanPosition = CGPoint(x: 1170, y: 40)
    static let cookingMeatNodeSize = CGSize(width: 175, height: 175)
    static let cookingMeatOffset = CGPoint(x: -10, y: -13)
    static let cookingProgressBarSize = CGSize(width: 120, height: 12)
    static let progressBarAssetNodeSize = CGSize(width: 126, height: 154)
    static let progressBarVisibleSize = CGSize(width: 120, height: 14.5)
    static let progressBarVisualOffset = CGPoint(x: 0, y: -2.4)
    static let orderProgressBarWidth: CGFloat = 200
    static let orderProgressBarOffset = CGPoint(
        x: 5.3,
        y: orderBubbleSize.height / 2 + -40 - progressBarVisualOffset.y
    )
    static let bunIsianVerticalOffset = 12.0
    static let bunDoneMeatVerticalOffset = 20.0
    static let burgerVerticalOffset = 18.0
    static let emotionOffset = CGPoint(x: 20, y: 100)
    static let orderBubbleOffset = CGPoint(x: 178, y: 50)
    static let orderBubbleSize = CGSize(width: 260, height: 180)
    static let orderBurgerSize = CGSize(width: 120, height: 120)

    static let creatureSpawnDelay: TimeInterval = 1
    static let creatureFadeDuration: TimeInterval = 0.4
    static let happyEmotionDuration: TimeInterval = 1
    static let timeoutEmotionDuration: TimeInterval = 1
    static let initialHungerDelay: TimeInterval = 0.5
    static let hungerRandomWindow: ClosedRange<TimeInterval> = 0...0
    static let cooldownDuration: TimeInterval = 12
    static let cookProgressDuration: TimeInterval = 6
    static let goodThreshold: Double = 0.5
    static let perfectZoneWidth: Double = 0.15
    static let perfectZoneStart = 1 - perfectZoneWidth
    static let feedingCycleTimeout: TimeInterval = 35
}
