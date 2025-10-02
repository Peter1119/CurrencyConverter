//
//  ExchangeRateCell.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 9/30/25.
//

import UIKit
import SnapKit

final class ExchangeRateCell: UITableViewCell {

    private var model: ExchangeRateCellModel?

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteButton.removeTarget(nil, action: nil, for: .allEvents)
    }

    func configure(with model: ExchangeRateCellModel) {
        self.model = model
        updateUI()

        favoriteButton.removeTarget(nil, action: nil, for: .allEvents)
        favoriteButton.addAction(UIAction(handler: { [weak model] _ in
            model?.onFavoriteTap?()
        }), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func updateUI() {
        guard let model = model else { return }
        currencyLabel.text = model.currency
        explanationLabel.text = model.description
        rateLabel.text = model.rateText
        trendIndicatorLabel.text = model.trendEmoji
        favoriteButton.isSelected = model.isFavorite
    }
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()

    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private lazy var currencyStackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(self.currencyLabel)
        stack.addArrangedSubview(self.explanationLabel)
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        label.textColor = .gray
        return label
    }()
    
    private let trendIndicatorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemBlue
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = .systemYellow
        return button
    }()
    
    private lazy var rightContentView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.addArrangedSubview(rateLabel)
        stack.addArrangedSubview(trendIndicatorLabel)
        stack.addArrangedSubview(favoriteButton)
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()


    private func setup() {
        selectionStyle = .none
        contentView.addSubview(currencyStackView)
        contentView.addSubview(rightContentView)
    }
    
    private func layout() {
        currencyStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(8)
        }

        rightContentView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(currencyStackView.snp.trailing).offset(16)
        }

        trendIndicatorLabel.snp.makeConstraints { make in
            make.width.equalTo(20) // 이모지 너비 고정
        }

        favoriteButton.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
    }
}

#Preview {
    let cell = ExchangeRateCell(style: .default, reuseIdentifier: nil)
    cell.configure(with: ExchangeRateCellModel(
        currency: "USD",
        description: "달러",
        rate: 89.8234,
        isIncreasing: true
    ))
    return cell
}
