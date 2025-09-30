//
//  ExchangeRateCell.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 9/30/25.
//

import UIKit
import SnapKit

final class ExchangeRateCell: UIView {
    
    private var model: ExchangeRateCellModel
    
    init(_ model: ExchangeRateCellModel) {
        self.model = model
        super.init(frame: .zero)

        self.setup()
        self.layout()
        self.setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }

    private func updateUI() {
        currencyLabel.text = model.currency
        explanationLabel.text = model.description
        rateLabel.text = model.rateText
        trendIndicatorLabel.text = model.trendEmoji
        favoriteButton.isSelected = model.isFavorite
    }

    private func setupActions() {
        favoriteButton.addAction(UIAction(handler: { [weak model] _ in
            model?.isFavorite.toggle()
            model?.onTap?(model?.id ?? String())
        }), for: .touchUpInside)
    }
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
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
        label.font = .systemFont(ofSize: 17, weight: .medium)
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
        stack.setCustomSpacing(8, after: trendIndicatorLabel)
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()

    
    private func setup() {
        self.addSubview(currencyStackView)
        self.addSubview(rightContentView)
    }
    
    private func layout() {
        currencyStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        
        rightContentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
    }
}

#Preview {
    ExchangeRateCell(
        ExchangeRateCellModel(
            currency: "USD",
            description: "달러",
            rate: 89.8234,
            isIncreasing: true
        )
    )
}
