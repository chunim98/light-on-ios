//
//  PolicyDetailAlert.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class PolicyDetailAlert: BaseAlertVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: Components
    
    let textView = TextView()
    
    private let acceptButton = {
        let button = LOButton(style: .filled, height: 45)
        button.setTitle("확인", .pretendard.semiBold(16))
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
        contentVStack.addArrangedSubview(LOSpacer(8))
        contentVStack.addArrangedSubview(textView)
        contentVStack.addArrangedSubview(LOSpacer(28))
        contentVStack.addArrangedSubview(acceptButton)
        
        textView.snp.makeConstraints { $0.height.equalTo(300) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        acceptButton.tapPublisher
            .sink { [weak self] _ in self?.dismiss(animated: true) }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { PolicyDetailAlert() }
