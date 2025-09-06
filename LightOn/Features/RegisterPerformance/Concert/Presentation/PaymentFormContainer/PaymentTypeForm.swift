//
//  PaymentTypeForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/13/25.
//

import UIKit
import Combine

final class PaymentTypeForm: BaseForm {
    
    // MARK: Components
    
    let radioControll = {
        let radio = RadioControll(isRequired: true)
        radio.titles = ["무료공연", "유료공연"]
        return radio
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        titleLabel.config.text = "공연 비용"
        spacing = 12
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(radioControll)
    }
}

// MARK: Binders & Publishers

extension PaymentTypeForm {
    /// 비용 발생 여부 퍼블리셔
    var isPaidPublisher: AnyPublisher<Bool, Never> {
        radioControll.selectedIndexPublisher.map { $0 == 1 }
            .prepend(false) // 초기값 제공
            .share()
            .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { PaymentTypeForm() }
