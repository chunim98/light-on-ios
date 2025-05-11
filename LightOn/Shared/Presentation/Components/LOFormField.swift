//
//  LOFormField.swift
//  LightOn
//
//  Created by 신정욱 on 5/11/25.
//

import UIKit
import Combine

import SnapKit

final class LOFormField: UIStackView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let isEssential: Bool
    var invalidCaptionText: String?
    var validCaptionText: String?

    // MARK: Components
    
    private let headerHStack = UIStackView(spacing: 2, inset: .init(horizontal: 16))
    private let bodyHStack = UIStackView(spacing: 12)
    private let footerHStack = UIStackView(inset: .init(leading: 2))
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .pretendard.semiBold(14)
        label.textColor = .infoText
        return label
    }()
    
    private let essentialMarkLabel = {
        let label = UILabel()
        label.font = .pretendard.semiBold(14)
        label.textColor = .destructive
        label.text = "*"
        return label
    }()
    
    private let textField = LOTextField()
    
    private let captionIconLabel = {
        let il = LOIconLabel()
        il.font = .pretendard.regular(12)
        il.isHidden = true
        il.spacing = 3
        return il
    }()
    
    // MARK: Life Cycle
    
    init(isEssential: Bool = false, isSecureTextEntry: Bool = false) {
        self.isEssential = isEssential
        self.textField.isSecureTextEntry = isSecureTextEntry
        super.init(frame: .zero)
        
        axis = .vertical
        spacing = 6
        setAutoLayout()
        setBinding()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        addArrangedSubview(headerHStack)
        addArrangedSubview(bodyHStack)
        addArrangedSubview(footerHStack)
        headerHStack.addArrangedSubview(titleLabel)
        if isEssential { headerHStack.addArrangedSubview(essentialMarkLabel) }
        headerHStack.addArrangedSubview(UIView())
        bodyHStack.addArrangedSubview(textField)
        footerHStack.addArrangedSubview(captionIconLabel)
        
        textField.snp.makeConstraints { $0.height.equalTo(47) }
        footerHStack.snp.makeConstraints { $0.height.equalTo(18) }
    }
    
    // MARK: Bindig
    
    private func setBinding() {
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
                self?.titleLabel.textColor = .infoText
            }
            .store(in: &cancellables)
    }
    
    // MARK: Configuration
    
    func setTitle       (_ text: String) { titleLabel.text = text }
    func setPlaceHolder (_ text: String) { textField.setPlaceHolder(text) }
    func addTrailingButton(_ button: UIButton) { bodyHStack.addArrangedSubview(button) }
    
    func showInvalidCaption() {
        captionIconLabel.icon = UIImage(resource: .formFieldExclamation)
        captionIconLabel.text = invalidCaptionText
        captionIconLabel.setColor(.destructive)
        captionIconLabel.isHidden = false
    }
    
    func showValidCaption() {
        captionIconLabel.icon = UIImage(resource: .formFieldCheck)
        captionIconLabel.text = validCaptionText
        captionIconLabel.setColor(.brand)
        captionIconLabel.isHidden = false
    }
}

#Preview { LOFormField(isEssential: true, isSecureTextEntry: true) }
