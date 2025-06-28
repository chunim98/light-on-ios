//
//  NameForm.swift
//  LightOn
//
//  Created by 신정욱 on 6/29/25.
//

import UIKit
import Combine

import CombineCocoa

final class NameForm: TextForm {
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        textField.setPlaceHolder("이름을 입력해주세요.")
        titleLabel.config.text = "이름"
    }
}

// MARK: Binders & Publishers

extension NameForm {
    /// 이름 퍼블리셔(아무것도 없으면 nil)
    var validNamePublisher: AnyPublisher<String?, Never> {
        textField.textPublisher
            .compactMap { $0 }
            .map { $0.isEmpty ? nil : $0 }
            .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { NameForm() }
