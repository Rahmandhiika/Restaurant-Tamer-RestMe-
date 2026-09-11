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
    private let cookingProgressBar = ProgressBarNode()
    private let orderProgressBar = ProgressBarNode()
    private let goodThreshold = SKShapeNode(rectOf: CGSize(
        width: 4,
        height: GameConfig.progressBarVisibleSize.height
    ))
    private let perfectZone = SKShapeNode(rectOf: CGSize(
        width: GameConfig.progressBarVisibleSize.width * GameConfig.perfectZoneWidth,
        height: GameConfig.progressBarVisibleSize.height
    ))
    private var isDraggingDish = false
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

        hungerIndicator = SKSpriteNode()
        hungerIndicator.size = CGSize(width: 38, height: 38)
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
        orderBurger.position = CGPoint(x: 6, y: 6)

        orderProgressBar.position = orderBubble.position + GameConfig.orderProgressBarOffset
        orderProgressBar.xScale = GameConfig.orderProgressBarWidth / GameConfig.progressBarVisibleSize.width
        orderProgressBar.zPosition = 2
        orderProgressBar.isHidden = true
        addChild(orderProgressBar)

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

        cookingProgressBar.position = CGPoint(
            x: GameConfig.panPosition.x,
            y: GameConfig.panPosition.y + GameConfig.ingredientNodeSize.height / 2
        )
        cookingProgressBar.name = NodeName.pan
        cookingProgressBar.zPosition = 2
        addChild(cookingProgressBar)

        let barOriginX = cookingProgressBar.position.x - GameConfig.progressBarVisibleSize.width / 2
        let barY = cookingProgressBar.position.y + GameConfig.progressBarVisualOffset.y

        goodThreshold.position = CGPoint(
            x: barOriginX + GameConfig.progressBarVisibleSize.width * GameConfig.goodThreshold,
            y: barY
        )
        goodThreshold.name = NodeName.pan
        goodThreshold.fillColor = .white
        goodThreshold.strokeColor = .clear
        goodThreshold.zPosition = 3
        addChild(goodThreshold)

        perfectZone.position = CGPoint(
            x: barOriginX + GameConfig.progressBarVisibleSize.width * (GameConfig.perfectZoneStart + GameConfig.perfectZoneWidth / 2),
            y: barY
        )
        perfectZone.name = NodeName.pan
        perfectZone.fillColor = .clear
        perfectZone.strokeColor = .green
        perfectZone.lineWidth = 4
        perfectZone.zPosition = 3
        addChild(perfectZone)

        setCookingProgressVisibility(false)
        cookingProgressBar.setProgress(0)
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

        feedingViewModel.$orderProgress
            .sink { [weak self] progress in
                self?.orderProgressBar.setProgress(1 - progress)
            }
            .store(in: &cancellables)

        feedingViewModel.$creatureEmotion
            .sink { [weak self] emotion in
                self?.setCreatureEmotion(emotion)
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
        feedingViewModel.advanceOrderTimer(by: currentTime - lastUpdateTime)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let node = atPoint(touch.location(in: self))

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
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
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
        cookingProgressBar.isHidden = !isCooking
        goodThreshold.isHidden = !isCooking
        perfectZone.isHidden = !isCooking
    }

    private func setCookingProgress(_ progress: Double) {
        cookingProgressBar.setProgress(progress)
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

    private func render(_ state: FeedingState) {
        hungerIndicator.isHidden = state != .hungry && state != .celebrating && state != .timedOut
        orderBubble.isHidden = state != .hungry
        orderProgressBar.isHidden = state != .hungry

        switch state {
        case .appearing:
            creature.fadeIn(duration: GameConfig.creatureFadeDuration)
        case .cooldown:
            creature.run(.fadeOut(withDuration: GameConfig.creatureFadeDuration))
        case .waiting, .hungry, .celebrating, .timedOut:
            break
        }
    }

    private func setCreatureEmotion(_ emotion: CreatureEmotion?) {
        let imageName: String?

        switch emotion {
        case .waitingForFood:
            imageName = "Emotion3"
        case .perfect:
            imageName = "Emotion1"
        case .good:
            imageName = "Emotion2"
        case .low:
            imageName = "Emotion4"
        case nil:
            imageName = nil
        }

        hungerIndicator.texture = imageName.map(SKTexture.init(imageNamed:))
    }
}

private final class ProgressBarNode: SKNode {
    private let fillMask = SKSpriteNode(color: .white, size: .zero)
    private let assetNodeSize = GameConfig.progressBarAssetNodeSize

    override init() {
        super.init()

        let track = SKSpriteNode(imageNamed: "ProgressBarTrack")
        track.size = assetNodeSize
        addChild(track)

        let fillCrop = SKCropNode()
        fillCrop.zPosition = 1

        let fill = SKSpriteNode(imageNamed: "ProgressBarFill")
        fill.size = assetNodeSize
        fillCrop.addChild(fill)

        fillMask.anchorPoint = CGPoint(x: 0, y: 0.5)
        fillMask.position = CGPoint(x: -assetNodeSize.width / 2, y: 0)
        fillCrop.maskNode = fillMask
        addChild(fillCrop)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setProgress(_ progress: Double) {
        fillMask.size = CGSize(
            width: assetNodeSize.width * max(0, min(progress, 1)),
            height: assetNodeSize.height
        )
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
