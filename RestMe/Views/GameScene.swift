//
//  GameScene.swift
//  RestMe
//
//  Created by Rahmandhika Putra Purwdi Wicaksono on 05/09/26.
//

import SpriteKit
import Combine

final class GameScene: SKScene {
    private enum NodeName {
        static let pan = "pan"
        static let trashCan = "trashCan"
        static let serveDish = "serveDish"
        static let burnedMeat = "burnedMeat"
    }

    private let feedingViewModel = FeedingViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var creature: CreatureNode!
    private var hungerIndicator: SKSpriteNode!
    private let orderBubble = SKSpriteNode(imageNamed: "BubbleChat")
    private let orderBurger = SKSpriteNode(imageNamed: "BurgerV2")
    private let serveDish = SKNode()
    private let plateNode = SKSpriteNode(imageNamed: "Plate")
    private let foodNode = SKSpriteNode()
    private let panNode = SKSpriteNode(imageNamed: "Pan")
    private let cookingMeatNode = SKSpriteNode()
    private let trashCanNode = SKSpriteNode(imageNamed: "TrashCan")
    private let progressTrack = SKSpriteNode(color: .darkGray, size: GameConfig.cookingProgressBarSize)
    private let progressFill = SKSpriteNode(color: .yellow, size: GameConfig.cookingProgressBarSize)
    private let greenZone = SKShapeNode(rectOf: CGSize(
        width: GameConfig.cookingProgressBarSize.width * GameConfig.greenZoneWidth,
        height: GameConfig.cookingProgressBarSize.height
    ))
    private var isDraggingDish = false
    private var isDraggingBurnedMeat = false
    private var lastUpdateTime: TimeInterval = 0

    override func didMove(to view: SKView) {
        scaleMode = .aspectFill

        let background = SKSpriteNode(imageNamed: "FullBackground")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        addChild(background)

        creature = CreatureNode()
        creature.position = CGPoint(x: size.width * 0.38, y: size.height * 0.62)
        creature.alpha = 0
        addChild(creature)

        hungerIndicator = SKSpriteNode(imageNamed: "Emotion4")
        hungerIndicator.size = CGSize(width: 48, height: 48)
        hungerIndicator.position = creature.position + GameConfig.emotionOffset
        hungerIndicator.isHidden = true
        addChild(hungerIndicator)

        orderBubble.size = GameConfig.orderBubbleSize
        orderBubble.position = creature.position + GameConfig.orderBubbleOffset
        orderBubble.zPosition = 1
        orderBubble.isHidden = true
        addChild(orderBubble)

        orderBurger.size = GameConfig.orderBurgerSize
        orderBubble.addChild(orderBurger)

        setupServeDish()
        setupCookingArea()
        setupTrashCan()
        observeGameState()

        addChild(makeDispenser(.bun, imageNamed: "PlateBun", position: CGPoint(x: 100, y: 280)))
        addChild(makeDispenser(.rawMeat, imageNamed: "PlateRawMeat", position: CGPoint(x: 295, y: 280)))
        addChild(makeDispenser(.filling, imageNamed: "PlateIsian", position: CGPoint(x: 100, y: 160)))
        addChild(makeDispenser(.plate, imageNamed: "Plate", position: CGPoint(x: 295, y: 160)))

        feedingViewModel.start()
    }

    private func setupServeDish() {
        serveDish.name = NodeName.serveDish
        serveDish.position = servingPosition
        serveDish.zPosition = 2
        serveDish.isHidden = true

        plateNode.size = GameConfig.ingredientNodeSize
        plateNode.zPosition = 0
        serveDish.addChild(plateNode)

        foodNode.size = GameConfig.ingredientNodeSize
        foodNode.zPosition = 1
        serveDish.addChild(foodNode)

        addChild(serveDish)
    }

    private func setupCookingArea() {
        panNode.name = NodeName.pan
        panNode.size = GameConfig.ingredientNodeSize
        panNode.position = GameConfig.panPosition
        addChild(panNode)

        cookingMeatNode.size = GameConfig.cookingMeatNodeSize
        cookingMeatNode.position = GameConfig.cookingMeatOffset
        cookingMeatNode.zPosition = 1
        cookingMeatNode.isHidden = true
        panNode.addChild(cookingMeatNode)

        progressTrack.position = CGPoint(
            x: GameConfig.panPosition.x,
            y: GameConfig.panPosition.y + GameConfig.ingredientNodeSize.height / 2
        )
        progressTrack.name = NodeName.pan
        progressTrack.zPosition = 2
        addChild(progressTrack)

        progressFill.anchorPoint = CGPoint(x: 0, y: 0.5)
        progressFill.position = CGPoint(
            x: progressTrack.position.x - GameConfig.cookingProgressBarSize.width / 2,
            y: progressTrack.position.y
        )
        progressFill.name = NodeName.pan
        progressFill.zPosition = 3
        addChild(progressFill)

        greenZone.position = progressTrack.position
        greenZone.name = NodeName.pan
        greenZone.fillColor = .clear
        greenZone.strokeColor = .green
        greenZone.lineWidth = 2
        greenZone.zPosition = 4
        addChild(greenZone)

        setCookingProgressVisibility(false)
        setCookingVisual(nil)
    }

    private func setupTrashCan() {
        trashCanNode.name = NodeName.trashCan
        trashCanNode.size = GameConfig.ingredientNodeSize
        trashCanNode.position = GameConfig.trashCanPosition
        addChild(trashCanNode)
    }

    private func observeGameState() {
        feedingViewModel.$state
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)

        feedingViewModel.$assemblyVisual
            .sink { [weak self] visual in
                self?.setAssemblyVisual(visual)
            }
            .store(in: &cancellables)

        feedingViewModel.$cookingProgress
            .sink { [weak self] progress in
                self?.setCookingProgress(progress)
            }
            .store(in: &cancellables)

        feedingViewModel.$isCooking
            .sink { [weak self] isCooking in
                self?.setCookingProgressVisibility(isCooking)
            }
            .store(in: &cancellables)

        feedingViewModel.$cookingVisual
            .sink { [weak self] visual in
                self?.setCookingVisual(visual)
            }
            .store(in: &cancellables)

    }

    private func makeDispenser(_ ingredient: Ingredient, imageNamed name: String, position: CGPoint) -> SKSpriteNode {
        let dispenser = SKSpriteNode(imageNamed: name)
        dispenser.size = GameConfig.ingredientNodeSize
        dispenser.position = position
        dispenser.name = ingredient.rawValue
        return dispenser
    }

    override func update(_ currentTime: TimeInterval) {
        defer { lastUpdateTime = currentTime }

        guard lastUpdateTime > 0 else {
            return
        }

        feedingViewModel.advanceCooking(by: currentTime - lastUpdateTime)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let node = atPoint(touch.location(in: self))

        if feedingViewModel.cookingVisual == .burned,
           hasAncestor(named: NodeName.pan, from: node) {
            beginBurnedMeatDrag(at: touch.location(in: self))
            return
        }

        if let ingredient = ingredient(at: node) {
            _ = feedingViewModel.tap(ingredient)
            return
        }

        if hasAncestor(named: NodeName.pan, from: node) {
            _ = feedingViewModel.finishCooking()
            return
        }

        if let assemblyVisual = feedingViewModel.assemblyVisual,
           assemblyVisual != .plate,
           hasAncestor(named: NodeName.serveDish, from: node) {
            isDraggingDish = true
            serveDish.zPosition = 10
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        if isDraggingDish {
            serveDish.position = touch.location(in: self)
        } else if isDraggingBurnedMeat {
            cookingMeatNode.position = touch.location(in: self)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        if isDraggingBurnedMeat {
            endBurnedMeatDrag(at: touch.location(in: self))
            return
        }

        guard isDraggingDish else {
            return
        }

        isDraggingDish = false
        serveDish.zPosition = 2

        let location = touch.location(in: self)

        if trashCanNode.frame.contains(location) {
            _ = feedingViewModel.discardAssembly()
            return
        }

        guard creature.frame.contains(location), feedingViewModel.serve() else {
            returnServingDish()
            return
        }

        creature.run(.sequence([
            .scale(to: 0.4, duration: 0.12),
            .scale(to: 0.35, duration: 0.12)
        ]))
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDraggingBurnedMeat {
            isDraggingBurnedMeat = false
            returnBurnedMeatToPan()
        }

        if isDraggingDish {
            isDraggingDish = false
            serveDish.zPosition = 2
            returnServingDish()
        }
    }

    private var servingPosition: CGPoint {
        CGPoint(x: GameConfig.serveArea.midX, y: GameConfig.serveArea.midY)
    }

    private func setAssemblyVisual(_ visual: AssemblyVisual?) {
        serveDish.isHidden = visual == nil

        guard let visual else {
            return
        }

        if visual == .plate {
            serveDish.position = servingPosition
        }

        foodNode.position = CGPoint(x: 0, y: visual.foodVerticalOffset)
        foodNode.texture = visual.imageName.map(SKTexture.init(imageNamed:))
        foodNode.isHidden = visual.imageName == nil
    }

    private func setCookingProgressVisibility(_ isCooking: Bool) {
        progressTrack.isHidden = !isCooking
        progressFill.isHidden = !isCooking
        greenZone.isHidden = !isCooking
    }

    private func setCookingProgress(_ progress: Double) {
        progressFill.size.width = GameConfig.cookingProgressBarSize.width * progress
    }

    private func setCookingVisual(_ visual: CookingVisual?) {
        switch visual {
        case .raw:
            cookingMeatNode.name = NodeName.pan
            cookingMeatNode.texture = SKTexture(imageNamed: "RawMeat")
            cookingMeatNode.isHidden = false
        case .done:
            cookingMeatNode.name = NodeName.pan
            cookingMeatNode.texture = SKTexture(imageNamed: "DoneMeat")
            cookingMeatNode.isHidden = false
        case .burned:
            cookingMeatNode.name = NodeName.burnedMeat
            cookingMeatNode.texture = SKTexture(imageNamed: "BurnMeat")
            cookingMeatNode.isHidden = false
        case nil:
            cookingMeatNode.isHidden = true
        }
    }

    private func ingredient(at node: SKNode) -> Ingredient? {
        var currentNode: SKNode? = node

        while let node = currentNode {
            if let name = node.name, let ingredient = Ingredient(rawValue: name) {
                return ingredient
            }
            currentNode = node.parent
        }

        return nil
    }

    private func hasAncestor(named name: String, from node: SKNode) -> Bool {
        var currentNode: SKNode? = node

        while let node = currentNode {
            if node.name == name {
                return true
            }
            currentNode = node.parent
        }

        return false
    }

    private func returnServingDish() {
        serveDish.run(.move(to: servingPosition, duration: 0.15))
    }

    private func beginBurnedMeatDrag(at position: CGPoint) {
        guard !isDraggingBurnedMeat else {
            return
        }

        cookingMeatNode.removeFromParent()
        cookingMeatNode.position = position
        cookingMeatNode.zPosition = 10
        addChild(cookingMeatNode)
        isDraggingBurnedMeat = true
    }

    private func endBurnedMeatDrag(at position: CGPoint) {
        isDraggingBurnedMeat = false

        if trashCanNode.frame.contains(position) {
            _ = feedingViewModel.discardBurnedMeat()
        }

        returnBurnedMeatToPan()
    }

    private func returnBurnedMeatToPan() {
        cookingMeatNode.removeFromParent()
        cookingMeatNode.position = GameConfig.cookingMeatOffset
        cookingMeatNode.zPosition = 1
        panNode.addChild(cookingMeatNode)
    }

    private func render(_ state: FeedingState) {
        hungerIndicator.isHidden = state != .hungry && state != .celebrating
        orderBubble.isHidden = state != .hungry

        switch state {
        case .appearing:
            creature.fadeIn(duration: GameConfig.creatureFadeDuration)
        case .celebrating:
            hungerIndicator.texture = SKTexture(imageNamed: "Emotion2")
        case .hungry:
            hungerIndicator.texture = SKTexture(imageNamed: "Emotion4")
        case .cooldown:
            creature.run(.fadeOut(withDuration: GameConfig.creatureFadeDuration))
        case .waiting:
            break
        }
    }
}

private extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

private extension AssemblyVisual {
    var imageName: String? {
        switch self {
        case .plate:
            nil
        case .bun:
            "Bun"
        case .filling:
            "Isian"
        case .doneMeat:
            "DoneMeat"
        case .bunIsian:
            "BunIsian"
        case .bunDoneMeat:
            "BunDoneMeat"
        case .doneMeatIsian:
            "DoneMeatIsian"
        case .burger:
            "BurgerV2"
        }
    }
}
