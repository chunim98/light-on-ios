//
//  RegisterConcertVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class RegisterConcertVC: BaseRegisterPerfVC {
    
    // MARK: Components
    
    private let checkboxHStack = UIStackView(spacing: 18)
    
    private let seatTitleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .loBlack
        config.text = "좌석 정보"
        return LOLabel(config: config)
    }()
    
    /// 결제 여부 및 결제 정보 폼 컨테이너
    private let paymentContainer = PaymentFormContainerView()
    
    /// 좌석수 폼
    private let seatCountForm = {
        let form = TextForm()
        form.textField.keyboardType = .numberPad
        form.textField.setPlaceHolder("예매 가능한 좌석수를 입력해주세요")
        form.titleLabel.config.text = "좌석수"
        return form
    }()
    
    // MARK: Buttons
    
    /// 공연 등록 버튼
    private let confirmButton = {
        let button = LOButton(style: .filled)
        button.setTitle("등록하기", .pretendard.bold(16))
        return button
    }()
    
    private let standingCheckbox = {
        let button = Checkbox()
        button.titleConfig.text = "스탠딩석"
        return button
    }()
    
    private let freestyleCheckbox = {
        let button = Checkbox()
        button.titleConfig.text = "자율좌석"
        return button
    }()
    
    private let assignedCheckbox = {
        let button = Checkbox()
        button.titleConfig.text = "지정좌석"
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.insertArrangedSubview(LOSpacer(24), at: 12)
        contentVStack.insertArrangedSubview(paymentContainer, at: 13)
        
        contentVStack.insertArrangedSubview(LOSpacer(20), at: 23)
        contentVStack.insertArrangedSubview(seatTitleLabel, at: 24)
        contentVStack.insertArrangedSubview(LOSpacer(16), at: 25)
        contentVStack.insertArrangedSubview(seatCountForm, at: 26)
        contentVStack.insertArrangedSubview(LOSpacer(20), at: 27)
        contentVStack.insertArrangedSubview(checkboxHStack, at: 28)
        contentVStack.insertArrangedSubview(LOSpacer(40), at: 29)
        
        checkboxHStack.addArrangedSubview(standingCheckbox)
        checkboxHStack.addArrangedSubview(freestyleCheckbox)
        checkboxHStack.addArrangedSubview(assignedCheckbox)
        checkboxHStack.addArrangedSubview(LOSpacer())
        
        // 오버레이 뷰 레이아웃
        paymentContainer.accountForm.bankDropdown.setupOverlayLayout(superView: contentVStack)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 배경을 터치하면, 오버레이 닫기
        contentVStack.tapPublisher
            .sink { [weak self] in self?.bindDismissOverlay(gesture: $0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension RegisterConcertVC {
    /// 배경을 터치하면, 오버레이 닫기
    private func bindDismissOverlay(gesture: UITapGestureRecognizer) {
        paymentContainer.accountForm.bankDropdown.dismissTable(gesture)
    }
}

// MARK: - Preview

#Preview { RegisterConcertVC() }
