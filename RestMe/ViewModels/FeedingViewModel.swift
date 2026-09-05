import Foundation
import Combine

final class FeedingViewModel: ObservableObject {
    @Published private(set) var state: FeedingState = .waiting

    func start() {
        let delay = GameConfig.initialHungerDelay + Double.random(in: GameConfig.hungerRandomWindow)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.state = .hungry
        }
    }
}
