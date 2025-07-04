//
//  RegisterPerformanceEntryModalVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class RegisterPerformanceEntryModalVC: ModalVC {
    
    // MARK: Components
    
    private let normalButton = {
        let button = RegisterPerformanceRowButton()
        button.descriptionLabel.config.text = "아티스트 회원만 등록이 가능합니다."
        button._titleLabel.config.text = "일반공연"
        button._imageView.image = .cdSquareFill
        return button
    }()
    
    private let buskingButton = {
        let button = RegisterPerformanceRowButton()
        button.descriptionLabel.config.text = "일반 회원도 등록이 가능합니다."
        button._titleLabel.config.text = "버스킹"
        button._imageView.image = .noteSquareFill
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(contentVStack.frame.height)
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        sheetPresentationController?.detents = [.custom { _ in 220.6 }] // 사전 계산한 모달 높이
        titleLabel.config.text = "어떤 공연을 등록할까요?"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.addArrangedSubview(LOSpacer(28))
        contentVStack.addArrangedSubview(normalButton)
        contentVStack.addArrangedSubview(LOSpacer(20))
        contentVStack.addArrangedSubview(buskingButton)
        contentVStack.addArrangedSubview(LOSpacer(28))
    }
}

// MARK: Binders & Publishers

extension RegisterPerformanceEntryModalVC {
    /// 일반 공연 버튼 탭
    var normalTapPublisher: AnyPublisher<Void, Never> { normalButton.tapPublisher }
    /// 버스킹 버튼 탭
    var buskingTapPublisher: AnyPublisher<Void, Never> { buskingButton.tapPublisher }
}

// MARK: - Preview

#Preview { RegisterPerformanceEntryModalVC() }
