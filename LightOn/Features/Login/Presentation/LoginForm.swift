//
//  LoginForm.swift
//  LightOn
//
//  Created by 신정욱 on 5/18/25.
//

import UIKit
import Combine

import CombineCocoa

final class LoginForm: NTextForm {
    
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
        asteriskLabel.isHidden = true
        setStyle(phase: .idle)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        Publishers.Merge(
            textField.didBeginEditingPublisher.map { FormPhase.focused },
            textField.controlEventPublisher(for: .editingDidEnd).map { FormPhase.filled }
        )
        .sink { [weak self] in self?.setStyle(phase: $0) }
        .store(in: &cancellables)
    }
    
    // MARK: Style
    
    override func setStyle(phase: FormPhase) {
        switch phase {
        case .idle, .filled, .error:
            titleLabel.config.foregroundColor = .infoText
            textField.layer.borderColor = UIColor.thumbLine.cgColor
            
        case .focused:
            titleLabel.config.foregroundColor = .brand
            textField.layer.borderColor = UIColor.brand.cgColor
        }
    }
}
