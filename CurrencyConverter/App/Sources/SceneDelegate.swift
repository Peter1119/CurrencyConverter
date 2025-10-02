//
//  SceneDelegate.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 9/30/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Core Data Context 가져오기
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.newBackgroundContext()

        // Dependency Injection
        let localDatasource = DefaultLocalExchangeRateDataSource(context: context)
        let remoteDatasource = DefaultRemoteExchangeRateDataSource()
        let repository = DefaultExchangeRateRepository(
            remoteDataSource: remoteDatasource,
            localDataSource: localDatasource
        )
        let fetchExchangeRateUseCase = FetchExchangeRate(repository: repository)
        let updateFavoriteUseCase = UpdateFavorite(repository: repository)
        let viewModel = ExchangeRateViewModel(
            fetchExchangeRateUseCase: fetchExchangeRateUseCase,
            updateFavoriteUseCase: updateFavoriteUseCase
        )
        let viewController = ExchangeRateViewController(viewModel: viewModel)

        // Window 설정
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

