//
//  ExchangeRateViewController.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 9/30/25.
//

import UIKit
import SnapKit

final class ExchangeRateViewController: UIViewController {
    private let viewModel: ExchangeRateViewModel
    private var previousItems: [ExchangeRateCellModel] = []

    init(viewModel: ExchangeRateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "환율 정보"
        self.view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(ExchangeRateCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .always

        Task {
            await viewModel.send(.loadExchangeRates)
        }

        configure()
        layout()
        observeViewModel()
    }

    private func observeViewModel() {
        // Observable 변경 감지
        withObservationTracking {
            _ = viewModel.state.items
        } onChange: { [weak self] in
            Task { @MainActor [weak self] in
                self?.updateTableView()
                self?.observeViewModel()
            }
        }
    }

    private func updateTableView() {
        let currentItems = viewModel.state.items

        // 이전 데이터가 없으면 그냥 reload
        guard !previousItems.isEmpty else {
            previousItems = currentItems
            tableView.reloadData()
            return
        }

        // 데이터 변경사항 계산
        let previousIds = previousItems.map { $0.id }
        let currentIds = currentItems.map { $0.id }

        // ID 순서만 바뀐 경우 (즐겨찾기 토글) - 애니메이션과 함께 reload
        if Set(previousIds) == Set(currentIds) {
            UIView.transition(with: tableView, duration: 0.3, options: .curveEaseInOut) {
                self.tableView.reloadData()
            }
        } else {
            // 완전히 다른 데이터면 reload (애니메이션 없이)
            tableView.reloadData()
        }

        previousItems = currentItems
    }
    
    func configure() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(searchBar)
        searchBar.delegate = self
    }
    
    func layout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ExchangeRateViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        let model = viewModel.state.items[indexPath.row]
        let calculatorViewModel = CalculatorViewModel(
            currency: model.currency,
            countryName: model.description,
            exchangeRate: model.rate
        )
        let calculatorVC = CalculatorViewController(viewModel: calculatorViewModel)
        navigationController?.pushViewController(calculatorVC, animated: true)
    }
}

extension ExchangeRateViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.state.items.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: ExchangeRateCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: viewModel.state.items[indexPath.row])
        return cell
    }
}

extension ExchangeRateViewController: UISearchBarDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        Task {
            await viewModel.send(.updateSearchText(searchText))
        }
    }
}

#Preview {
    ExchangeRateViewController(
        viewModel: ExchangeRateViewModel(
            fetchExchangeRateUseCase: MockFetchExchangeRateUseCase(),
            updateFavoriteUseCase: MockUpdateFavoriteUseCase()
        )
    )
}
