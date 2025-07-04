//
//  UpdateTermsSectionStateUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/1/25.
//

import Combine

final class UpdateTermsSectionStateUC {
    /// 약관 동의 섹션 상태를 갱신
    func execute(
        serviceAgreed: AnyPublisher<Bool, Never>,
        privacyAgreed: AnyPublisher<Bool, Never>,
        isOver14: AnyPublisher<Bool, Never>,
        allAgreed: AnyPublisher<Bool, Never>,
        state: AnyPublisher<TermsSectionState, Never>
    ) -> AnyPublisher<TermsSectionState, Never> {
        
        let eachButtonsEvent = Publishers.MergeMany(
            serviceAgreed.withLatestFrom(state) { $1.updated(serviceAgreed: $0) },
            privacyAgreed.withLatestFrom(state) { $1.updated(privacyAgreed: $0) },
            isOver14.withLatestFrom(state) { $1.updated(isOver14: $0) }
        )
        
        let allAgreedEvent = allAgreed.withLatestFrom(state) {
            $1.updated(serviceAgreed: $0, privacyAgreed: $0, isOver14: $0)
        }
        
        return Publishers.Merge(
            eachButtonsEvent,
            allAgreedEvent
        )
        .eraseToAnyPublisher()
    }
}
