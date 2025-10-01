//
//  ExchangeRateViewController.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 9/30/25.
//

import UIKit
import SnapKit

final class ExchangeRateViewController: UIViewController {
    private let viewModel = ExchangeRateViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(ExchangeRateCell.self)
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await viewModel.send(.loadExchangeRates)
        }
        
        configure()
        layout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        tableView.reloadData()
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
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension ExchangeRateViewController: UITableViewDelegate {
    
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

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let model = viewModel.state.items[indexPath.row]
        // TODO: 화면 이동
        print("셀 선택: \(model.currency)")
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
    ExchangeRateViewController()
}
