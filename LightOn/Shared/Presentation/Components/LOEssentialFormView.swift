//
//  LOEssentialFormView.swift
//  LightOn
//
//  Created by 신정욱 on 5/17/25.
//

import UIKit
import Combine

import SnapKit

final class LOEssentialFormView: LOFormView {

    // MARK: Components
    
    private let footerHStack = UIStackView(inset: .init(leading: 2))
    
    private let essentialMarkLabel = {
        let label = UILabel()
        label.font = .pretendard.semiBold(14)
        label.textColor = .destructive
        label.text = "*"
        return label
    }()
        
    private let captionIconLabel = {
        let il = LOIconLabel()
        il.font = .pretendard.regular(12)
        il.isHidden = true
        il.spacing = 3
        return il
    }()
    
    // MARK: Life Cycle
    
    override init(isSecureTextEntry: Bool = false) {
        super.init(isSecureTextEntry: isSecureTextEntry)
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(footerHStack)
        headerHStack.addArrangedSubview(essentialMarkLabel)
        footerHStack.addArrangedSubview(captionIconLabel)
        footerHStack.snp.makeConstraints { $0.height.equalTo(18) }
    }
    
    // MARK: Public Configuration
    
    func setInvalidCaption(text: String) {
        captionIconLabel.icon = UIImage(resource: .formFieldExclamation)
        captionIconLabel.text = text
        captionIconLabel.setColor(.destructive)
        captionIconLabel.isHidden = false
    }
    
    func setValidCaption(text: String) {
        captionIconLabel.icon = UIImage(resource: .formFieldCheck)
        captionIconLabel.text = text
        captionIconLabel.setColor(.brand)
        captionIconLabel.isHidden = false
    }
}

// MARK: - Preview

#Preview {
    let formView = LOEssentialFormView()
    formView.setTitle("아이디")
    formView.setInvalidCaption(text: "옴메나..")
    return formView
}
