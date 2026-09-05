import SpriteKit

final class GameScene: SKScene {
    override func didMove(to view: SKView) {
        scaleMode = .aspectFill

        let background = SKSpriteNode(imageNamed: "FullBackground")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        addChild(background)

        let creature = CreatureNode()
        creature.position = CGPoint(x: size.width * 0.62, y: size.height * 0.68)
        addChild(creature)
        creature.fadeIn()
    }
}
