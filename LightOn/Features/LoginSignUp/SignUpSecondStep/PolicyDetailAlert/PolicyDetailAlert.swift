//
//  PolicyDetailAlert.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit

import SnapKit

final class PolicyDetailAlert: AlertBase {

    // MARK: Components
    
    let textView = TextView()
    
    let acceptButton = {
        let button = TPButton(style: .filled, height: 45)
        button.setTitle("확인", .pretendard.semiBold(16))
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.addArrangedSubview(Spacer(8))
        contentVStack.addArrangedSubview(textView)
        contentVStack.addArrangedSubview(Spacer(28))
        contentVStack.addArrangedSubview(acceptButton)
        
        textView.snp.makeConstraints { $0.height.equalTo(300) }
    }
}

// MARK: - Preview

#Preview { PolicyDetailAlert() }
