//
//  Coordinator.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/2/25.
//

import UIKit

@MainActor
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }

    func start()
    func start(with currencyCode: String?)
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }

    // 기본 구현
    func start(with currencyCode: String?) {
        start()
    }
}
