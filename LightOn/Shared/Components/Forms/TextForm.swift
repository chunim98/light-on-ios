//
//  TextForm.swift
//  LightOn
//
//  Created by 신정욱 on 5/23/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

class TextForm: BaseForm {
    
    // MARK: Components
    
    let textFieldHStack = UIStackView()
    
    let textField = {
        let tf = LOTintedTextField()
        tf.snp.makeConstraints { $0.height.equalTo(47) }
        return tf
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(textFieldHStack)
        textFieldHStack.addArrangedSubview(textField)
    }
}

// MARK: Binders & Publishers

extension TextForm {
    /// 폼 텍스트 퍼블리셔 (비어있는 경우 nil)
    var textPublisher: AnyPublisher<String?, Never> {
        textField.textPublisher
            .map { $0.flatMap { $0.isEmpty ? nil : $0 } }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
