import SpriteKit
import Combine

final class GameScene: SKScene {
    private let feedingViewModel = FeedingViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var creature: CreatureNode!
    private var hungerIndicator: SKSpriteNode!

    override func didMove(to view: SKView) {
        scaleMode = .aspectFill

        let background = SKSpriteNode(imageNamed: "FullBackground")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        addChild(background)

        creature = CreatureNode()
        creature.position = CGPoint(x: size.width * 0.62, y: size.height * 0.68)
        addChild(creature)
        creature.fadeIn()

        hungerIndicator = SKSpriteNode(imageNamed: "Emotion4")
        hungerIndicator.size = CGSize(width: 48, height: 48)
        hungerIndicator.position = CGPoint(x: creature.position.x, y: creature.position.y + 110)
        hungerIndicator.isHidden = true
        addChild(hungerIndicator)

        feedingViewModel.$state
            .sink { [weak self] state in
                self?.hungerIndicator.isHidden = state != .hungry
            }
            .store(in: &cancellables)

        feedingViewModel.start()
    }
}
