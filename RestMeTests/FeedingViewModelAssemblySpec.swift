@main
enum FeedingViewModelAssemblySpec {
    static func main() {
        verifyPlateFirst()
        verifyFoodVisuals()
        verifyBunMeatOffset()
        verifyCookedMeatCompletesBurger()
        verifyServeStartsCelebration()
        verifyMeatOnlyTransfersAfterGreenZone()
        verifyExpiredMeatMustBeDiscarded()
        verifyFilledPlateCanBeDiscarded()
        verifyOrderTimerExpires()
    }

    private static func verifyPlateFirst() {
        let viewModel = FeedingViewModel()

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

    private static func verifyMeatOnlyTransfersAfterGreenZone() {
        let viewModel = plated()

        precondition(viewModel.tap(.rawMeat))
        viewModel.advanceCooking(by: GameConfig.cookProgressDuration * 0.4)
        precondition(viewModel.cookingVisual == .raw)
        precondition(viewModel.finishCooking() == nil)
        precondition(viewModel.assemblyVisual == .plate)

        viewModel.advanceCooking(by: GameConfig.cookProgressDuration * 0.1)
        precondition(viewModel.cookingVisual == .done)
        precondition(viewModel.finishCooking() != nil)
        precondition(viewModel.assemblyVisual == .doneMeat)
    }

    private static func verifyExpiredMeatMustBeDiscarded() {
        let viewModel = plated()

        precondition(viewModel.tap(.rawMeat))
        viewModel.advanceCooking(by: GameConfig.cookProgressDuration)
        precondition(viewModel.cookingVisual == .burned)
        precondition(!viewModel.isCooking)
        precondition(viewModel.cookingProgress == 1)
        precondition(viewModel.discardBurnedMeat())
        precondition(viewModel.cookingVisual == nil)
        precondition(viewModel.tap(.rawMeat))
    }

    private static func verifyFilledPlateCanBeDiscarded() {
        let viewModel = plated(.bun)

        precondition(viewModel.discardAssembly())
        precondition(viewModel.assemblyVisual == nil)
        precondition(viewModel.tap(.plate))
    }

    private static func verifyOrderTimerExpires() {
        let viewModel = FeedingViewModel()

        viewModel.beginHunger()
        viewModel.advanceOrderTimer(by: GameConfig.feedingCycleTimeout / 2)
        precondition(viewModel.orderProgress == 0.5)

        viewModel.advanceOrderTimer(by: GameConfig.feedingCycleTimeout / 2)
        precondition(viewModel.orderProgress == 0)
        precondition(viewModel.state == .cooldown)
    }

    private static func plated(_ ingredients: Ingredient...) -> FeedingViewModel {
        let viewModel = FeedingViewModel()
        precondition(viewModel.tap(.plate))
        ingredients.forEach { ingredient in
            precondition(viewModel.tap(ingredient))
        }
        return viewModel
    }

    private static func cookPerfectMeat(for viewModel: FeedingViewModel) {
        precondition(viewModel.tap(.rawMeat))
        viewModel.advanceCooking(by: GameConfig.cookProgressDuration / 2)
        precondition(viewModel.cookingVisual == .done)
        precondition(viewModel.finishCooking() == .perfect)
    }
}
