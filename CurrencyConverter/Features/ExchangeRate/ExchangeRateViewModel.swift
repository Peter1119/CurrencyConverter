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
            state.allItems = ExchangeRateCellModel.mockData

        case .toggleFavorite(let id):
            guard let index = state.allItems.firstIndex(where: { $0.id == id }) else { return }
            print("어느게 들어오는거야 ? \(id)")
            state.allItems[index].isFavorite.toggle()

        case .updateSearchText(let text):
            state.searchText = text

        case .refresh:
            state.allItems = ExchangeRateCellModel.mockData
        }
    }
}
