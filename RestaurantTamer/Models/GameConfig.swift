import Foundation

/// Parameter dev/testing untuk feeding loop & Grill minigame.
/// Nilai final (dari GDD Restaurant Tamer) ada di docs/PRD.md §6 — ganti sebelum demo.
enum GameConfig {

    // MARK: - Feeding loop timing

    static let initialBubbleDelay: TimeInterval = 4
    static let bubbleWindowMin: TimeInterval = 3
    static let bubbleWindowMax: TimeInterval = 10
    static let cooldownDuration: TimeInterval = 12

    // MARK: - Grill minigame

    static let grillDuration: TimeInterval = 8
    static let greenZoneCenter: CGFloat = 0.5
    static let greenZoneWidth: CGFloat = 0.15 // ± dari center, fraksi 0...1
}
