//
//  LoginForm.swift
//  LightOn
//
//  Created by 신정욱 on 5/18/25.
//

import UIKit
import Combine

import CombineCocoa

final class LoginForm: TextForm {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupBindings()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        textField.layer.borderColor = UIColor.thumbLine.cgColor
        titleLabel.config.foregroundColor = .infoText
        asteriskLabel.isHidden = true
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        
        textField.didBeginEditingPublisher.sink { [weak self] _ in
            self?.titleLabel.config.foregroundColor = .brand
            self?.textField.layer.borderColor = UIColor.brand.cgColor
        }
        .store(in: &cancellables)
        
        textField.controlEventPublisher(for: .editingDidEnd).sink { [weak self] _ in
            self?.titleLabel.config.foregroundColor = .infoText
            self?.textField.layer.borderColor = UIColor.thumbLine.cgColor
        }
        .store(in: &cancellables)
    }
}
