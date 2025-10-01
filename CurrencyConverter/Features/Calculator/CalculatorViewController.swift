//
//  CalculatorViewController.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 9/30/25.
//

import UIKit
import SnapKit

final class CalculatorViewController: UIViewController {
    private let viewModel: CalculatorViewModel

    init(
        currency: String,
        countryName: String,
        exchangeRate: Double
    ) {
        self.viewModel = CalculatorViewModel(
            currency: currency,
            countryName: countryName,
            exchangeRate: exchangeRate
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Components
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    private lazy var labelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [currencyLabel, countryLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()

    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.textAlignment = .center
        textField.placeholder = "금액을 입력하세요"
        return textField
    }()

    private let convertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("환율 계산", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        return button
    }()

    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = "계산 결과가 여기에 표시됩니댜."
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configure()
        layout()
    }

    private func configure() {
        self.navigationItem.title = "환율 계산기"
        currencyLabel.text = viewModel.state.currency
        countryLabel.text = viewModel.state.countryName

        view.addSubview(labelStackView)
        view.addSubview(amountTextField)
        view.addSubview(convertButton)
        view.addSubview(resultLabel)

        amountTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    private func layout() {
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
        }

        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }

        convertButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(convertButton.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }

    @objc private func textFieldDidChange() {
        viewModel.send(.updateAmount(amountTextField.text ?? ""))
    }

    @objc private func convertButtonTapped() {
        viewModel.send(.convert)
        resultLabel.text = viewModel.state.resultText
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

#Preview {
    CalculatorViewController(currency: "USD", countryName: "미국 달러", exchangeRate: 1300.50)
}
