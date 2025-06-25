//
//  LOFormView.swift
//  LightOn
//
//  Created by 신정욱 on 5/11/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

class LOFormView: UIStackView {

    // MARK: Components
    
    private let bodyHStack = UIStackView(spacing: 12)
    private let titleView = LOFormTitleView(isEssential: false)
    private let textField = LOFormTextField()
    private let captionView = LOFormValidationCaptionView()
    
    // MARK: Life Cycle
    
    init(isSecureTextEntry: Bool = false) {
        self.textField.isSecureTextEntry = isSecureTextEntry
        super.init(frame: .zero)
        setupDefaults()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        axis = .vertical
        spacing = 6
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(titleView)
        addArrangedSubview(bodyHStack)
        addArrangedSubview(captionView)
        bodyHStack.addArrangedSubview(textField)
        textField.snp.makeConstraints { $0.height.equalTo(47) }
    }
    
    // MARK: Public Configuration
    
    func addTrailingButton(_ button: UIButton) {
        bodyHStack.addArrangedSubview(button)
    }

    func setTitle(_ text: String) { titleView.setText(text) }
    func setTitleColor(_ color: UIColor) { titleView.setColor(color) }
    func setEssentialMarkVisibility(_ visibility: Bool) {
        titleView.setEssentialMarkVisibility(visibility)
    }
    
    func setPlaceHolder(_ text: String) { textField.setPlaceHolder(text) }
    func setBorderColor(_ color: UIColor) { textField.setBorderColor(color) }
    
    func setInvalidCaption(_ text: String) { captionView.setInvalidCaption(text) }
    func setValidCaption(_ text: String) { captionView.setValidCaption(text) }
}

// MARK: Binders & Publishers

extension LOFormView {
    var textPublisher: AnyPublisher<String?, Never> {
        textField.textPublisher
    }
    
    var editingBeginPublisher: AnyPublisher<Void, Never> {
        textField.didBeginEditingPublisher
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    var editingEndPublisher: AnyPublisher<Void, Never> {
        textField.returnPublisher
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview {
    let formView = LOFormView()
    formView.setTitle("아이디")
    formView.setValidCaption("오키!")
    return formView
}
