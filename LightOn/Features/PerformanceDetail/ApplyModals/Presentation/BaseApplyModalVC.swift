//
//  BaseApplyModalVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/16/25.
//

import UIKit
import Combine

import CombineCocoa

class BaseApplyModalVC: ModalVC {
    
    // MARK: Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let buttonsHStack = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    let descriptionLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(18)
        config.foregroundColor = .caption
        config.paragraphSpacing = 8
        config.alignment = .center
        config.lineHeight = 24
        let label = LOLabel(config: config)
        label.numberOfLines = .max
        return label
    }()
    
    let acceptButton = LOButton(style: .filled)
    
    let cancelButton = {
        let button = LOButton(style: .bordered)
        button.setTitle("취소", .pretendard.regular(16))
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { titleLabel.config.text = "공연 신청" }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.addArrangedSubview(LOSpacer(8))
        contentVStack.addArrangedSubview(descriptionLabel)
        contentVStack.addArrangedSubview(LOSpacer(28))
        contentVStack.addArrangedSubview(buttonsHStack)
        contentVStack.addArrangedSubview(LOSpacer(28))
        
        buttonsHStack.addArrangedSubview(cancelButton)
        buttonsHStack.addArrangedSubview(acceptButton)
    }
}

// MARK: Binders & Publishers

extension BaseApplyModalVC {
    // 확인(승인) 버튼 탭 퍼블리셔
    var acceptTapPublisher: AnyPublisher<Void, Never> {
        acceptButton.tapPublisher
    }
    
    // 취소 버튼 탭 퍼블리셔
    var cancelTapPublisher: AnyPublisher<Void, Never> {
        cancelButton.tapPublisher
    }
}
