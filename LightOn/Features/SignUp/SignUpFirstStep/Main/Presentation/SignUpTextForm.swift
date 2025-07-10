//
//  SignUpTextForm.swift
//  LightOn
//
//  Created by 신정욱 on 5/29/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class SignUpTextForm: TextForm {
    
    // MARK: Struct
    
    struct CaptionConfiguration {
        let text: String
        let isValid: Bool
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    let captionHStack = UIStackView(spacing: 3, inset: .init(leading: 2))
    
    let captionIconView = UIImageView(contentMode: .scaleAspectFit)
    let captionLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        return LOLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { textField.autocapitalizationType = .none }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(captionHStack)
        captionHStack.addArrangedSubview(captionIconView)
        captionHStack.addArrangedSubview(captionLabel)
        
        captionIconView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        
        textField.didBeginEditingPublisher.sink { [weak self] _ in
            self?.titleLabel.config.foregroundColor = .brand
            self?.textField.layer.borderColor = UIColor.brand.cgColor
        }
        .store(in: &cancellables)
        
        textField.controlEventPublisher(for: .editingDidEnd).sink { [weak self] _ in
            self?.titleLabel.config.foregroundColor = .caption
            self?.textField.layer.borderColor = UIColor.thumbLine.cgColor
        }
        .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension SignUpTextForm {
    
    func captionConfigBinder(config: CaptionConfiguration?) {
        if let config {
            captionIconView.image = config.isValid ?
                .formFieldCheck :
                .formFieldExclamation
            
            captionLabel.config.foregroundColor = config.isValid ?
                .brand :
                .destructive
            
            captionLabel.config.text = config.text
            captionHStack.isHidden = false
            
        } else {
            captionHStack.isHidden = true
        }
    }
}
