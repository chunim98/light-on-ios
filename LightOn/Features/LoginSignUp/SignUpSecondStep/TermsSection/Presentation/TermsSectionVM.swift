//
//  TermsSectionVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/1/25.
//

import Foundation
import Combine

final class TermsSectionVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let serviceAgreed: AnyPublisher<Bool, Never>
        let privacyAgreed: AnyPublisher<Bool, Never>
        let isOver14: AnyPublisher<Bool, Never>
        let allAgreed: AnyPublisher<Bool, Never>
    }
    
    struct Output {
        /// 모든 항목에 동의했는지 여부
        let isAllAgreed: AnyPublisher<Bool, Never>
        /// 약관 동의 섹션 상태
        let policySectionState: AnyPublisher<TermsSectionState, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let updateStateUC = UpdateTermsSectionStateUC()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let stateSubject = CurrentValueSubject<TermsSectionState, Never>(.init(
            serviceAgreed: false, privacyAgreed: false, isOver14: false
        ))
        
        updateStateUC.execute(
            serviceAgreed: input.serviceAgreed,
            privacyAgreed: input.privacyAgreed,
            isOver14: input.isOver14,
            allAgreed: input.allAgreed,
            state: stateSubject.eraseToAnyPublisher()
        )
        .sink { stateSubject.send($0) }
        .store(in: &cancellables)
        
        let isAllAgreed = stateSubject
            .map {
                $0.serviceAgreed &&
                $0.privacyAgreed &&
                $0.isOver14
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        return Output(
            isAllAgreed: isAllAgreed,
            policySectionState: stateSubject.eraseToAnyPublisher()
        )
    }
}
