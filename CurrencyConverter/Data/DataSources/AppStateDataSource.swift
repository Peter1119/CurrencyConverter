//
//  AppStateDataSource.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/2/25.
//

import Foundation
import CoreData

enum LastScreen: String {
    case exchangeRateList
    case calculator
}

struct AppState {
    let lastScreen: LastScreen
    let lastCurrencyCode: String?
}

protocol AppStateDataSource {
    func saveAppState(_ state: AppState) async throws
    func loadAppState() async throws -> AppState?
}

final class DefaultAppStateDataSource: AppStateDataSource {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveAppState(_ state: AppState) async throws {
        try await context.perform {
            // 기존 상태 삭제
            let fetchRequest: NSFetchRequest<AppStateEntity> = AppStateEntity.fetchRequest()
            let existingStates = try self.context.fetch(fetchRequest)
            existingStates.forEach { self.context.delete($0) }

            // 새 상태 저장
            let entity = AppStateEntity(context: self.context)
            entity.lastScreen = state.lastScreen.rawValue
            entity.lastCurrencyCode = state.lastCurrencyCode

            try self.context.save()
            print("✅ [AppState] 상태 저장 완료 - \(state.lastScreen.rawValue), \(state.lastCurrencyCode ?? "nil")")
        }
    }

    func loadAppState() async throws -> AppState? {
        try await context.perform {
            let fetchRequest: NSFetchRequest<AppStateEntity> = AppStateEntity.fetchRequest()
            guard let entity = try self.context.fetch(fetchRequest).first else {
                print("📂 [AppState] 저장된 상태 없음")
                return nil
            }

            guard let screenType = LastScreen(rawValue: entity.lastScreen) else {
                print("⚠️ [AppState] 잘못된 화면 타입: \(entity.lastScreen)")
                return nil
            }

            let state = AppState(
                lastScreen: screenType,
                lastCurrencyCode: entity.lastCurrencyCode
            )
            print("📂 [AppState] 상태 로드 완료 - \(state.lastScreen.rawValue), \(state.lastCurrencyCode ?? "nil")")
            return state
        }
    }
}
