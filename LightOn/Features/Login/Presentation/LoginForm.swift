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

    // MARK: Struct
    
    struct Style {
        let titleColor: UIColor
        let borderColor: UIColor
        
        static var idle: Self { .init(titleColor: .infoText, borderColor: .thumbLine) }
        static var focused: Self { .init(titleColor: .brand, borderColor: .brand) }
        static var filled: Self { .init(titleColor: .loBlack, borderColor: .loBlack) }
    }
    
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
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let text = textField.textPublisher
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let isFocused = Publishers
            .Merge(
                textField.didBeginEditingPublisher.map { true },
                textField.controlEventPublisher(for: .editingDidEnd).map { false }
            )
            .eraseToAnyPublisher()
        
        let style = Publishers.CombineLatest(text, isFocused)
            .map { text, isFocused -> Style in
                guard !isFocused else { return .focused }
                return text.isEmpty ? .idle : .filled
            }
            .prepend(.idle) // 초기 스타일 할당
            .eraseToAnyPublisher()
        
        style
            .sink { [weak self] in
                self?.titleLabel.config.foregroundColor = $0.titleColor
                self?.textField.layer.borderColor = $0.borderColor.cgColor
            }
            .store(in: &cancellables)
    }
}
