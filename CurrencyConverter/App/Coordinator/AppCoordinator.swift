//
//  AppCoordinator.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/2/25.
//

import UIKit
import CoreData

final class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    private let context: NSManagedObjectContext
    private let appStateDataSource: AppStateDataSource

    init(navigationController: UINavigationController, context: NSManagedObjectContext) {
        self.navigationController = navigationController
        self.context = context
        self.appStateDataSource = DefaultAppStateDataSource(context: context)

        navigationController.navigationBar.prefersLargeTitles = true
    }

    func start() {
        start(with: nil)
    }

    func start(with currencyCode: String?) {
        let exchangeRateCoordinator = ExchangeRateCoordinator(
            navigationController: navigationController,
            context: context,
            appStateDataSource: appStateDataSource
        )
        addChildCoordinator(exchangeRateCoordinator)
        exchangeRateCoordinator.start(with: currencyCode)
    }
}
