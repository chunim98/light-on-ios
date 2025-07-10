//
//  SignUpFirstStepBaseForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

import UIKit
import Combine

import CombineCocoa

class SignUpFirstStepBaseForm: NTextForm {
    
    // MARK: Typealias
    
    typealias Style = SignUpFirstStepBaseFormStyle
    
    // MARK: Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    let captionView = SignUpFirstStepCaptionView()
    
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
    
    private func setupLayout() {
        addArrangedSubview(captionView)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let text = textField.textPublisher
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let isFocused = Publishers.Merge(
            textField.didBeginEditingPublisher.map { true },
            textField.controlEventPublisher(for: .editingDidEnd).map { false }
        ).eraseToAnyPublisher()
        
        let style = Publishers.CombineLatest(text, isFocused)
            .map { text, isFocused -> Style in
                guard !isFocused else { return .focused }
                return text.isEmpty ? .idle : .filled
            }
            .eraseToAnyPublisher()
        
        style
            .sink { [weak self] in self?.bindStyle($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension SignUpFirstStepBaseForm {
    /// 스타일 바인딩
    private func bindStyle(_ style: Style) {
        titleLabel.config.foregroundColor = style.titleColor
        textField.layer.borderColor = style.borderColor.cgColor
    }
}
