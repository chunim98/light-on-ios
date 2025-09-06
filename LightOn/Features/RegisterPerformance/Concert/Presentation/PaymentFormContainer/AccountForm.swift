//
//  AccountForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/13/25.
//

import UIKit
import Combine

import SnapKit

final class AccountForm: BaseForm {
    
    // MARK: Components
    
    let bankDropdown = {
        let view = DropdownView<BankCellItem>(placeholder: "은행명을 선택해주세요")
        view.setSnapshot(items: BankCellItem.banks)
        return view
    }()
    
    let accountHolderTextField = {
        let tf = LOTintedTextField()
        tf.setPlaceHolder("예금주명을 입력해주세요")
        tf.snp.makeConstraints { $0.height.equalTo(47) }
        return tf
    }()
    
    let accountNumberTextField = {
        let tf = LOTintedTextField()
        tf.keyboardType = .numberPad
        tf.setPlaceHolder("계좌번호를 입력해주세요 (숫자만 기입)")
        tf.snp.makeConstraints { $0.height.equalTo(47) }
        return tf
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
    
    private func setupDefaults() { titleLabel.config.text = "입금 계좌" }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(bankDropdown)
        addArrangedSubview(accountNumberTextField)
        addArrangedSubview(accountHolderTextField)
    }
}

// MARK: - Preview

#Preview { AccountForm() }
