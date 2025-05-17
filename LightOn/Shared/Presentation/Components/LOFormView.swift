//
//  LOFormView.swift
//  LightOn
//
//  Created by 신정욱 on 5/11/25.
//

import UIKit
import Combine

import SnapKit

class LOFormView: UIStackView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var titleColor: UIColor = .loBlack

    // MARK: Components
    
    let headerHStack = UIStackView(spacing: 2, inset: .init(horizontal: 16))
    private let bodyHStack = UIStackView(spacing: 12)
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .pretendard.semiBold(14)
        return label
    }()
    
    private let textField = LOTextField()
    
    // MARK: Life Cycle
    
    init(isSecureTextEntry: Bool = false) {
        self.textField.isSecureTextEntry = isSecureTextEntry
        super.init(frame: .zero)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        axis = .vertical
        spacing = 6
        
        titleLabel.textColor = titleColor
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(headerHStack)
        addArrangedSubview(bodyHStack)
        headerHStack.addArrangedSubview(titleLabel)
        bodyHStack.addArrangedSubview(textField)
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        textField.snp.makeConstraints { $0.height.equalTo(47) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 텍스트 필드 작성 시작 시, 색상 변경
        textField.publisher(for: .editingDidBegin)
            .sink { [weak self] _ in
                self?.textField.layer.borderColor = UIColor.brand.cgColor
                self?.titleLabel.textColor = .brand
            }
            .store(in: &cancellables)
        
        // 텍스트 필드 작성 종료 시, 색상 변경
        textField.publisher(for: .editingDidEnd)
            .sink { [weak self] _ in
                self?.textField.layer.borderColor = UIColor.thumbLine.cgColor
                self?.titleLabel.textColor = self?.titleColor
            }
            .store(in: &cancellables)
    }
    
    // MARK: Public Configuration

    func setTitle(_ text: String) { titleLabel.text = text }
    func setTitleColor(_ color: UIColor) {
        titleLabel.textColor = color
        titleColor = color
    }
    func setPlaceHolder(_ text: String) { textField.setPlaceHolder(text) }
    func addTrailingButton(_ button: UIButton) { bodyHStack.addArrangedSubview(button) }
}

// MARK: - Preview

#Preview {
    let formView = LOFormView()
    formView.setTitle("아이디")
    return formView
}
