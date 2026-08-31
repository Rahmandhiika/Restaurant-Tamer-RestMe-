import SpriteKit

/// Sprite makhluk. Placeholder bentuk lingkaran — belum ada art final (PRD §4.1).
final class CreatureNode: SKShapeNode {

    init(radius: CGFloat = 60) {
        super.init()
        path = CGPath(ellipseIn: CGRect(x: -radius, y: -radius, width: radius * 2, height: radius * 2), transform: nil)
        fillColor = .systemOrange
        strokeColor = .clear
        name = "creature"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
