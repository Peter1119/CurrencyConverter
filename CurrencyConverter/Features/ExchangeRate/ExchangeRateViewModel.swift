//
//  ExchangeRateViewModel.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation
import Observation

@MainActor
final class ExchangeRateViewModel: ViewModelProtocol {
    private let fetchExchangeRateUseCase: FetchExchangeRateUseCase
    private let updateFavoriteUseCase: UpdateFavoriteUseCase

    init(
        fetchExchangeRateUseCase: FetchExchangeRateUseCase,
        updateFavoriteUseCase: UpdateFavoriteUseCase
    ) {
        self.fetchExchangeRateUseCase = fetchExchangeRateUseCase
        self.updateFavoriteUseCase = updateFavoriteUseCase
    }
    
    @Observable
    class State {
        var allItems: [ExchangeRateCellModel] = []
        var searchText = ""

        var items: [ExchangeRateCellModel] {
            guard !searchText.isEmpty else { return allItems }
            return allItems.filter {
                $0.currency.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    enum Action {
        case loadExchangeRates
        case toggleFavorite(String)
        case updateSearchText(String)
        case refresh
    }

    let state: State = State()

    func send(_ action: Action) async {
        switch action {
        case .loadExchangeRates:
            await loadExchangeRates()

        case .toggleFavorite(let id):
            await toggleFavorite(id)

        case .updateSearchText(let text):
            state.searchText = text

        case .refresh:
            state.allItems = configureModels(ExchangeRateCellModel.mockData)
        }
    }

    // MARK: - Private Methods

    private func loadExchangeRates() async {
        do {
            let rates = try await fetchExchangeRateUseCase.execute()
            let models = rates.map { createCellModel(from: $0) }
            state.allItems = configureModels(models)
        } catch {
            print("❌ [ViewModel] 환율 데이터 로드 실패: \(error)")
            state.allItems = []
        }
    }

    private func toggleFavorite(_ id: String) async {
        guard let index = state.allItems.firstIndex(where: { $0.id == id }) else { return }

        let newFavoriteValue = !state.allItems[index].isFavorite

        do {
            let updatedRates = try await updateFavoriteUseCase.execute(id: id, isFavorite: newFavoriteValue)
            updateAllItems(with: updatedRates)
        } catch {
            print("❌ [ViewModel] 즐겨찾기 업데이트 실패: \(error)")
        }
    }

    private func updateAllItems(with rates: [ExchangeRate]) {
        let updatedModels = rates.map { rate -> ExchangeRateCellModel in
            if let existingModel = state.allItems.first(where: { $0.id == rate.code }) {
                existingModel.isFavorite = rate.isFavorite
                return existingModel
            } else {
                return createCellModel(from: rate)
            }
        }
        state.allItems = configureModels(updatedModels)
    }

    private func createCellModel(from rate: ExchangeRate) -> ExchangeRateCellModel {
        ExchangeRateCellModel(
            currency: rate.code,
            description: rate.name,
            rate: rate.rate,
            isIncreasing: rate.isIncreasing,
            isFavorite: rate.isFavorite
        )
    }

    private func configureModels(_ models: [ExchangeRateCellModel]) -> [ExchangeRateCellModel] {
        models.map { [weak self] model in
            if model.onFavoriteTap == nil {
                model.onFavoriteTap = {
                    Task {
                        await self?.send(.toggleFavorite(model.id))
                    }
                }
            }
            return model
        }
    }
}
