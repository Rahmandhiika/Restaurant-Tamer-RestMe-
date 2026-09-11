@main
enum FeedingViewModelAssemblySpec {
    static func main() {
        verifyInputsStayLockedUntilHungry()
        verifyPlateFirst()
        verifyFoodVisuals()
        verifyBunMeatOffset()
        verifyCookedMeatCompletesBurger()
        verifyServeStartsCelebration()
        verifyMeatOnlyTransfersAfterGoodThreshold()
        verifyFinalZoneMeatIsPerfect()
        verifyMissedPerfectBecomesLowAutomatically()
        verifyServingUsesTheMeatGradeForFeedback()
        verifyFilledPlateCanBeDiscarded()
        verifyTimeoutShowsLowFeedback()
    }

    private static func verifyInputsStayLockedUntilHungry() {
        let viewModel = FeedingViewModel()

        precondition(!viewModel.tap(.plate))
        precondition(!viewModel.tap(.rawMeat))

        viewModel.beginHunger()
        precondition(viewModel.tap(.plate))
    }

    private static func verifyPlateFirst() {
        let viewModel = FeedingViewModel()

        viewModel.beginHunger()

        precondition(!viewModel.tap(.bun))
        precondition(!viewModel.tap(.filling))
        precondition(!viewModel.tap(.rawMeat))
        precondition(viewModel.tap(.plate))
        precondition(viewModel.assemblyVisual == .plate)
        precondition(!viewModel.tap(.plate))
    }

    private static func verifyFoodVisuals() {
        let bun = plated(.bun)
        precondition(bun.assemblyVisual == .bun)

        let filling = plated(.filling)
        precondition(filling.assemblyVisual == .filling)

        let bunIsian = plated(.bun, .filling)
        precondition(bunIsian.assemblyVisual == .bunIsian)

        let bunDoneMeat = plated(.bun)
        cookPerfectMeat(for: bunDoneMeat)
        precondition(bunDoneMeat.assemblyVisual == .bunDoneMeat)

        let doneMeatIsian = plated(.filling)
        cookPerfectMeat(for: doneMeatIsian)
        precondition(doneMeatIsian.assemblyVisual == .doneMeatIsian)
    }

    private static func verifyCookedMeatCompletesBurger() {
        let viewModel = plated(.bun, .filling)
        cookPerfectMeat(for: viewModel)

        precondition(viewModel.assemblyVisual == .burger)
        precondition(viewModel.serve())
        precondition(viewModel.assemblyVisual == nil)
    }

    private static func verifyServeStartsCelebration() {
        let viewModel = plated(.bun, .filling)
        cookPerfectMeat(for: viewModel)

        precondition(viewModel.serve())
        precondition(viewModel.state == .celebrating)
    }

    private static func verifyBunMeatOffset() {
        precondition(AssemblyVisual.doneMeat.foodVerticalOffset == 0)
        precondition(AssemblyVisual.bunIsian.foodVerticalOffset == 12)
        precondition(AssemblyVisual.bunDoneMeat.foodVerticalOffset == 20)
        precondition(AssemblyVisual.burger.foodVerticalOffset == 18)
    }

    private static func verifyMeatOnlyTransfersAfterGoodThreshold() {
        let viewModel = plated()

        precondition(viewModel.tap(.rawMeat))
        viewModel.advanceCooking(by: GameConfig.cookProgressDuration * 0.4)
        precondition(viewModel.cookingVisual == .raw)
        precondition(viewModel.finishCooking() == nil)
        precondition(viewModel.assemblyVisual == .plate)

        viewModel.advanceCooking(by: GameConfig.cookProgressDuration * 0.1)
        precondition(viewModel.cookingVisual == .done)
        precondition(viewModel.finishCooking() == .good)
        precondition(viewModel.assemblyVisual == .doneMeat)
    }

    private static func verifyFinalZoneMeatIsPerfect() {
        let viewModel = plated()

        precondition(viewModel.tap(.rawMeat))
        viewModel.advanceCooking(by: GameConfig.cookProgressDuration * 0.9)
        precondition(viewModel.cookingVisual == .done)
        precondition(viewModel.finishCooking() == .perfect)
    }

    private static func verifyMissedPerfectBecomesLowAutomatically() {
        let viewModel = plated(.bun, .filling)

        precondition(viewModel.tap(.rawMeat))
        viewModel.advanceCooking(by: GameConfig.cookProgressDuration)
        precondition(viewModel.assemblyVisual == .burger)
        precondition(viewModel.meatGrade == .low)
        precondition(!viewModel.isCooking)
        precondition(viewModel.cookingVisual == nil)
    }

    private static func verifyServingUsesTheMeatGradeForFeedback() {
        let viewModel = plated(.bun, .filling)
        cookPerfectMeat(for: viewModel)

        precondition(viewModel.serve())
        precondition(viewModel.creatureEmotion == .perfect)
    }

    private static func verifyFilledPlateCanBeDiscarded() {
        let viewModel = plated(.bun)

        precondition(viewModel.discardAssembly())
        precondition(viewModel.assemblyVisual == nil)
        precondition(viewModel.tap(.plate))
    }

    private static func verifyTimeoutShowsLowFeedback() {
        let viewModel = FeedingViewModel()

        viewModel.beginHunger()
        viewModel.advanceOrderTimer(by: GameConfig.feedingCycleTimeout / 2)
        precondition(viewModel.orderProgress == 0.5)

        viewModel.advanceOrderTimer(by: GameConfig.feedingCycleTimeout / 2)
        precondition(viewModel.orderProgress == 0)
        precondition(viewModel.state == .timedOut)
        precondition(viewModel.creatureEmotion == .low)
    }

    private static func plated(_ ingredients: Ingredient...) -> FeedingViewModel {
        let viewModel = FeedingViewModel()
        viewModel.beginHunger()
        precondition(viewModel.tap(.plate))
        ingredients.forEach { ingredient in
            precondition(viewModel.tap(ingredient))
        }
        return viewModel
    }

    private static func cookPerfectMeat(for viewModel: FeedingViewModel) {
        precondition(viewModel.tap(.rawMeat))
        viewModel.advanceCooking(by: GameConfig.cookProgressDuration * 0.9)
        precondition(viewModel.cookingVisual == .done)
        precondition(viewModel.finishCooking() == .perfect)
    }
}
