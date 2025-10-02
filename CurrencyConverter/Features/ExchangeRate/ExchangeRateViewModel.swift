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
    
    init(fetchExchangeRateUseCase: FetchExchangeRateUseCase) {
        self.fetchExchangeRateUseCase = fetchExchangeRateUseCase
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
            do {
                let data = try await fetchExchangeRateUseCase.execute()
                let models: [ExchangeRateCellModel] = data.map {
                    ExchangeRateCellModel(
                        currency: $0.code,
                        description: $0.name,
                        rate: $0.rate,
                        isIncreasing: $0.isIncreasing
                    )
                }
                state.allItems = models.map { [weak self] model in
                    model.onFavoriteTap = {
                        Task {
                            await self?.send(.toggleFavorite(model.id))
                        }
                    }
                    return model
                }
            } catch {
                print("❌ [ViewModel] 환율 데이터 로드 실패: \(error)")
                state.allItems = []
            }

        case .toggleFavorite(let id):
            guard let index = state.allItems.firstIndex(where: { $0.id == id }) else { return }
            state.allItems[index].isFavorite.toggle()

        case .updateSearchText(let text):
            state.searchText = text

        case .refresh:
            state.allItems = ExchangeRateCellModel.mockData.map { [weak self] model in
                model.onFavoriteTap = {
                    Task {
                        await self?.send(.toggleFavorite(model.id))
                    }
                }
                return model
            }
        }
    }
}
