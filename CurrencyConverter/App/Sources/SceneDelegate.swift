//
//  SceneDelegate.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 9/30/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var coordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Core Data Context 가져오기
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.newBackgroundContext()

        // Coordinator 설정
        let navigationController = UINavigationController()
        let coordinator = AppCoordinator(navigationController: navigationController, context: context)
        self.coordinator = coordinator

        // 앱 상태 복원 및 시작
        Task {
            let appStateDataSource = DefaultAppStateDataSource(context: context)
            if let appState = try? await appStateDataSource.loadAppState(),
               appState.lastScreen == .calculator,
               let currencyCode = appState.lastCurrencyCode {
                await MainActor.run {
                    coordinator.start(with: currencyCode)
                }
            } else {
                await MainActor.run {
                    coordinator.start()
                }
            }
        }

        // Window 설정
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()

        guard let navigationController = window?.rootViewController as? UINavigationController,
              let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let context = appDelegate.persistentContainer.newBackgroundContext()
        let appStateDataSource = DefaultAppStateDataSource(context: context)

        Task {
            let topViewController = navigationController.viewControllers.last

            let appState: AppState
            if let calculatorVC = topViewController as? CalculatorViewController {
                // 환율 계산기 화면
                appState = AppState(
                    lastScreen: .calculator,
                    lastCurrencyCode: calculatorVC.viewModel.state.currency
                )
            } else {
                // 환율 리스트 화면
                appState = AppState(
                    lastScreen: .exchangeRateList,
                    lastCurrencyCode: nil
                )
            }

            try? await appStateDataSource.saveAppState(appState)
        }
    }
}

