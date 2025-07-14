//
//  CounterTextFormVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

import Foundation
import Combine

final class CounterTextFormVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let text: AnyPublisher<String, Never>
        let didBeginEditing: AnyPublisher<Void, Never>
        let didEndEditing: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 폼 상태
        let state: AnyPublisher<CounterTextFormState, Never>
        /// 유효한 텍스트
        let validText: AnyPublisher<String?, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let maxByte: Int
    
    private let updateStateUC = UpdateCounterTextFormStateUC()
    
    // MARK: Initializer
    
    init(maxByte: Int) {
        self.maxByte = maxByte
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let stateSubject = CurrentValueSubject<CounterTextFormState, Never>(.init(
            isEditing: false, isValid: false, isEmpty: true,
            text: "", maxByte: maxByte
        ))
        
        updateStateUC.execute(
            text: input.text,
            didBeginEditing: input.didBeginEditing,
            didEndEditing: input.didEndEditing,
            state: stateSubject.eraseToAnyPublisher()
        )
        .sink { stateSubject.send($0) }
        .store(in: &cancellables)
        
        let validText = stateSubject
            .map { $0.isValid && !$0.isEmpty ? $0.text : nil }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        return Output(
            state: stateSubject.eraseToAnyPublisher(),
            validText: validText
        )
    }
}
