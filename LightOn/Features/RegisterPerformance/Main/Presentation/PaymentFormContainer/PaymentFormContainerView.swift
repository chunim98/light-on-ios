//
//  PaymentFormContainerView.swift
//  LightOn
//
//  Created by 신정욱 on 7/13/25.
//

import UIKit
import Combine

final class PaymentFormContainerView: UIStackView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let paymentTypeForm = PaymentTypeForm()
    
    private let priceForm = {
        let form = TextForm()
        form.textField.keyboardType = .numberPad
        form.textField.setPlaceHolder("공연 비용을 적어주세요 (숫자만 기입)")
        form.titleLabel.config.text = "금액"
        return form
    }()
    
    let accountForm = AccountForm()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        axis = .vertical
        spacing = 16
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(paymentTypeForm)
        addArrangedSubview(priceForm)
        addArrangedSubview(accountForm)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        paymentTypeForm.isPaidPublisher
            .sink { [weak self] in
                self?.priceForm.isHidden = !$0
                self?.accountForm.isHidden = !$0
            }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension PaymentFormContainerView {
    /// 가격 퍼블리셔 (무료일 경우 nil)
    var pricePublisher: AnyPublisher<String?, Never> {
        Publishers.CombineLatest(
            priceForm.textPublisher,
            paymentTypeForm.isPaidPublisher
        )
        .map { price, isPaid in isPaid ? price : nil }
        .eraseToAnyPublisher()
    }
}
