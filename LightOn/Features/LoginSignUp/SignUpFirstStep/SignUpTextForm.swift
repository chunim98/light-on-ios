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

final class SignUpTextForm: TPTextForm {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let captionHStack = UIStackView(spacing: 3, inset: .init(leading: 2))
    
    private let captionIconView = UIImageView(contentMode: .scaleAspectFit)
    private let captionLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(12)
        return TPLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupBindings()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    func setupLayout() {
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
    func showValidCaptionBinder(_ text: String) {
        captionIconView.image = .formFieldCheck
        captionLabel.config.foregroundColor = .brand
        captionLabel.config.text = text
    }
    
    func showInvalidCaptionBinder(_ text: String) {
        captionIconView.image = .formFieldExclamation
        captionLabel.config.foregroundColor = .destructive
        captionLabel.config.text = text
    }
}
