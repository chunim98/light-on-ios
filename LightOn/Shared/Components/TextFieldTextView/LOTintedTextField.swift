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
    
    /// 값 설정시, 관련 UI 스타일도 함께 반영됨
    override var text: String? { didSet { updateTextSubject.send(text) } }
    
    // MARK: Subjects
    
    /// 텍스트 상태 업데이트 서브젝트
    /// - Note: 입력 목적
    private let updateTextSubject = PassthroughSubject<String?, Never>()
    
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
        /// 최종 텍스트
        ///
        /// - 사용자 편집 이벤트(updateTextSubject)
        /// - 외부에서 주입된 바인딩(textPublisher)
        /// 두 흐름을 병합하여 중복 제거 후 방출
        let text = Publishers
            .Merge(
                updateTextSubject.eraseToAnyPublisher(),
                textPublisher
            )
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        /// 사용자 작성중 여부
        ///
        /// 다운 스트림의 CombineLatest을 위해 초기값 제공중
        let isFocused = Publishers
            .Merge(
                controlEventPublisher(for: .editingDidEnd).map { false },
                didBeginEditingPublisher.map { true }
            )
            .prepend(false) // 초기값 제공
            .eraseToAnyPublisher()
        
        Publishers.CombineLatest(text, isFocused)
            .sink { [weak self] in
                let color: UIColor
                color = $1 ? .brand : ($0.isEmpty ? .thumbLine : .loBlack)
                self?.layer.borderColor = color.cgColor
            }
            .store(in: &cancellables)
    }
}
