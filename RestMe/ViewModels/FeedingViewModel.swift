//
//  FeedingViewModel.swift
//  RestMe
//
//  Created by Rahmandhika Putra Purwdi Wicaksono on 05/09/26.
//

import Foundation
import Combine

final class FeedingViewModel: ObservableObject {
    @Published private(set) var state: FeedingState = .waiting
    @Published private(set) var assemblyVisual: AssemblyVisual?
    @Published private(set) var cookingProgress = 0.0
    @Published private(set) var isCooking = false
    @Published private(set) var cookingVisual: CookingVisual?
    private var placedIngredients = Set<Ingredient>()

    func start() {
        scheduleAppearance(after: GameConfig.creatureSpawnDelay)
    }

    func serve() -> Bool {
        guard assemblyVisual == .burger else {
            return false
        }

        placedIngredients.removeAll()
        assemblyVisual = nil
        cookingProgress = 0
        isCooking = false
        cookingVisual = nil
        state = .celebrating

        DispatchQueue.main.asyncAfter(deadline: .now() + GameConfig.happyEmotionDuration) { [weak self] in
            self?.scheduleAppearance(after: GameConfig.cooldownDuration)
        }
        return true
    }

    private func scheduleAppearance(after delay: TimeInterval) {
        state = .cooldown
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self else {
                return
            }

            self.state = .appearing
            DispatchQueue.main.asyncAfter(deadline: .now() + GameConfig.initialHungerDelay) { [weak self] in
                guard let self else {
                    return
                }

                self.state = .waiting
                self.scheduleHunger(after: Double.random(in: GameConfig.hungerRandomWindow))
            }
        }
    }

    private func scheduleHunger(after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.state = .hungry
        }
    }

    func tap(_ ingredient: Ingredient) -> Bool {
        if ingredient == .rawMeat {
            return startCooking()
        }

        guard !placedIngredients.contains(ingredient) else {
            return false
        }

        guard ingredient == .plate || placedIngredients.contains(.plate) else {
            return false
        }

        placedIngredients.insert(ingredient)
        updateAssemblyVisual()
        return true
    }

    func advanceCooking(by elapsedTime: TimeInterval) {
        guard isCooking, elapsedTime > 0 else {
            return
        }

        cookingProgress = min(cookingProgress + elapsedTime / GameConfig.cookProgressDuration, 1)

        if cookingProgress == 1 {
            isCooking = false
            cookingVisual = .burned
        } else if cookingProgress >= greenZoneStart {
            cookingVisual = .done
        }
    }

    func finishCooking() -> Grade? {
        guard isCooking, cookingVisual == .done else {
            return nil
        }

        isCooking = false
        let grade = Grade.grade(for: cookingProgress)
        cookingProgress = 0
        cookingVisual = nil
        placedIngredients.insert(.doneMeat)
        updateAssemblyVisual()
        return grade
    }

    func discardBurnedMeat() -> Bool {
        guard cookingVisual == .burned else {
            return false
        }

        cookingProgress = 0
        cookingVisual = nil
        return true
    }

    func discardAssembly() -> Bool {
        guard let assemblyVisual, assemblyVisual != .plate else {
            return false
        }

        placedIngredients.removeAll()
        self.assemblyVisual = nil
        return true
    }

    private func startCooking() -> Bool {
        guard placedIngredients.contains(.plate),
              !placedIngredients.contains(.doneMeat),
              cookingVisual == nil else {
            return false
        }

        cookingProgress = 0
        isCooking = true
        cookingVisual = .raw
        return true
    }

    private var greenZoneStart: Double {
        0.5 - GameConfig.greenZoneWidth / 2
    }

    private func updateAssemblyVisual() {
        guard placedIngredients.contains(.plate) else {
            assemblyVisual = nil
            return
        }

        let hasBun = placedIngredients.contains(.bun)
        let hasFilling = placedIngredients.contains(.filling)
        let hasDoneMeat = placedIngredients.contains(.doneMeat)

        switch (hasBun, hasFilling, hasDoneMeat) {
        case (false, false, false):
            assemblyVisual = .plate
        case (true, false, false):
            assemblyVisual = .bun
        case (false, true, false):
            assemblyVisual = .filling
        case (false, false, true):
            assemblyVisual = .doneMeat
        case (true, true, false):
            assemblyVisual = .bunIsian
        case (true, false, true):
            assemblyVisual = .bunDoneMeat
        case (false, true, true):
            assemblyVisual = .doneMeatIsian
        case (true, true, true):
            assemblyVisual = .burger
        }
    }
}
