import SpriteKit

final class GameScene: SKScene {

    private let creature = CreatureNode()

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.95, green: 0.90, blue: 0.80, alpha: 1)
        creature.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(creature)
    }
}
