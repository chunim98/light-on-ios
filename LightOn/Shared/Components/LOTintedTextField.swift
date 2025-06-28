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
        didBeginEditingPublisher
            .sink { [weak self] _ in
                self?.layer.borderColor = UIColor.brand.cgColor
            }
            .store(in: &cancellables)
        
        controlEventPublisher(for: .editingDidEnd)
            .sink { [weak self] _ in
                self?.layer.borderColor = UIColor.thumbLine.cgColor
            }
            .store(in: &cancellables)
    }
}
