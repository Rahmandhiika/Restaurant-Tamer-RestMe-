import Foundation

enum GameConfig {
    static let sceneSize = CGSize(width: 1194, height: 834)

    static let initialHungerDelay: TimeInterval = 4
    static let hungerRandomWindow: ClosedRange<TimeInterval> = 3...10
    static let cooldownDuration: TimeInterval = 12
    static let cookProgressDuration: TimeInterval = 8
    static let greenZoneWidth: Double = 0.15
    static let feedingCycleTimeout: TimeInterval = 35
}
