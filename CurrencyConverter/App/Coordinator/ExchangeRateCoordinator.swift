//
//  ExchangeRateCoordinator.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/2/25.
//

import UIKit
import CoreData

final class ExchangeRateCoordinator: Coordinator {
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    private let context: NSManagedObjectContext
    private let appStateDataSource: AppStateDataSource
    private let repository: ExchangeRateRepository

    init(
        navigationController: UINavigationController,
        context: NSManagedObjectContext,
        appStateDataSource: AppStateDataSource
    ) {
        self.navigationController = navigationController
        self.context = context
        self.appStateDataSource = appStateDataSource

        let remoteDataSource = DefaultRemoteExchangeRateDataSource()
        let localDataSource = DefaultLocalExchangeRateDataSource(context: context)
        self.repository = DefaultExchangeRateRepository(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
    }

    func start() {
        start(with: nil)
    }

    func start(with currencyCode: String?) {
        let exchangeRateVC = makeExchangeRateViewController()
        navigationController.pushViewController(exchangeRateVC, animated: false)

        // 앱 상태 복원
        if let currencyCode = currencyCode {
            Task {
                await pushToCalculator(currencyCode: currencyCode)
            }
        }
    }

    func pushToCalculator(currencyCode: String) async {
        await MainActor.run {
            let fetchExchangeRateUseCase = FetchExchangeRate(repository: repository)
            let calculatorViewModel = CalculatorViewModel(
                fetchExchangeRateUseCase: fetchExchangeRateUseCase,
                currencyCode: currencyCode
            )
            let calculatorVC = CalculatorViewController(viewModel: calculatorViewModel)
            calculatorVC.coordinator = self
            navigationController.pushViewController(calculatorVC, animated: true)

            // 앱 상태 저장
            Task {
                try? await appStateDataSource.saveAppState(
                    AppState(lastScreen: .calculator, lastCurrencyCode: currencyCode)
                )
            }
        }
    }

    func popViewController() {
        navigationController.popViewController(animated: true)
    }

    // MARK: - Private Methods

    @MainActor
    private func makeExchangeRateViewController() -> ExchangeRateViewController {
        let fetchExchangeRateUseCase = FetchExchangeRate(repository: repository)
        let updateFavoriteUseCase = UpdateFavorite(repository: repository)

        let viewModel = ExchangeRateViewModel(
            fetchExchangeRateUseCase: fetchExchangeRateUseCase,
            updateFavoriteUseCase: updateFavoriteUseCase
        )

        let viewController = ExchangeRateViewController(viewModel: viewModel)
        viewController.coordinator = self

        return viewController
    }
}
