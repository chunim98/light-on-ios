//
//  PerformanceNameFormVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/5/25.
//

import Foundation
import Combine

final class PerformanceNameFormVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let text: AnyPublisher<String, Never>
        let didBeginEditing: AnyPublisher<Void, Never>
        let didEndEditing: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 이름 폼 상태
        let state: AnyPublisher<PerformanceNameFormState, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let updateStateUC = UpdatePerformanceNameFormStateUC()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let stateSubject = CurrentValueSubject<PerformanceNameFormState, Never>(.init(
            text: "", byte: 0, isEditing: false, style: .empty
        ))
        
        updateStateUC.execute(
            text: input.text,
            didBeginEditing: input.didBeginEditing,
            didEndEditing: input.didEndEditing,
            state: stateSubject.eraseToAnyPublisher()
        )
        .sink { stateSubject.send($0) }
        .store(in: &cancellables)
        
        return Output(state: stateSubject.eraseToAnyPublisher())
    }
}
