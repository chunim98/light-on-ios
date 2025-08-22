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
        /// 사용자 작성중 여부
        ///
        /// 다운 스트림의 CombineLatest을 위해 초기값 제공
        let isFocused = Publishers
            .Merge(
                controlEventPublisher(for: .editingDidEnd).map { false },
                didBeginEditingPublisher.map { true }
            )
            .prepend(false) // 초기값 제공
            .eraseToAnyPublisher()
        
        /// 현재 텍스트
        let text = textChangesPublisher
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        // 현재 상태를 바탕으로 UI 업데이트
        Publishers.CombineLatest(isFocused, text)
            .sink { [weak self] in
                let color: UIColor = $0 ? .brand : ($1.isEmpty ? .thumbLine : .loBlack)
                self?.layer.borderColor = color.cgColor
            }
            .store(in: &cancellables)
    }
}
