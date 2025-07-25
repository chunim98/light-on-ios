//
//  RegisterBuskingConfirmAlertVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import UIKit
import Combine

import CombineCocoa

final class RegisterBuskingConfirmAlertVC: BaseAlertVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let buttonHStack = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    let acceptButton = {
        let button = LOButton(style: .filled)
        button.setTitle("등록", .pretendard.semiBold(16))
        return button
    }()
    
    private let cancelButton = {
        let button = LOButton(style: .bordered)
        button.setTitle("취소", .pretendard.regular(16))
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        titleLabel.config.text = "공연을 등록하시겠습니까?"
        descriptionLabel.config.text = """
        버스킹 공연은 반드시\u{2028}허가된 장소에서만 진행하셔야 합니다.
        허가되지 않은 장소에서의 공연으로\u{2028}발생하는 모든 책임은 주최자에게 있습니다.
        """
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.addArrangedSubview(LOSpacer(28))
        contentVStack.addArrangedSubview(buttonHStack)
        
        buttonHStack.addArrangedSubview(cancelButton)
        buttonHStack.addArrangedSubview(acceptButton)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        cancelButton.tapPublisher
            .sink { [weak self] _ in self?.dismiss(animated: true) }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { RegisterBuskingConfirmAlertVC() }
