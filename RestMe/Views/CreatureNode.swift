import SpriteKit

final class CreatureNode: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "Creature")
        super.init(texture: texture, color: .clear, size: texture.size())
        setScale(0.35)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fadeIn(duration: TimeInterval = 0.6) {
        alpha = 0
        run(.fadeIn(withDuration: duration))
    }
}
