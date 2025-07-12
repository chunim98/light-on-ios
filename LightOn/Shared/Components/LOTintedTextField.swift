//
//  LOTintedTextField.swift
//  LightOn
//
//  Created by 신정욱 on 6/29/25.
//

import UIKit
import Combine

import CombineCocoa

final class LOTintedTextField: LOTextField {
    
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
        let text = textPublisher
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let isFocused = Publishers.Merge(
            didBeginEditingPublisher.map { true },
            controlEventPublisher(for: .editingDidEnd).map { false }
        ).eraseToAnyPublisher()
        
        Publishers.CombineLatest(text, isFocused)
            .sink { [weak self] in
                let color: UIColor
                color = $1 ? .brand : ($0.isEmpty ? .thumbLine : .loBlack)
                self?.layer.borderColor = color.cgColor
            }
            .store(in: &cancellables)
    }
}
