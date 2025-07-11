//
//  TintedTextForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/12/25.
//

import UIKit
import Combine

import CombineCocoa

class TintedTextForm: NTextForm {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBindings()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        Publishers.CombineLatest(text, isFocused)
            .sink { [weak self] in
                let color: UIColor
                color = $1 ? .brand : ($0.isEmpty ? .thumbLine : .loBlack)
                self?.textField.layer.borderColor = color.cgColor
            }
            .store(in: &cancellables)
    }
}
