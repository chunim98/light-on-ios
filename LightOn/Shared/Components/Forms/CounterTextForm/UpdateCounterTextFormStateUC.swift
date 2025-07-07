//
//  UpdateCounterTextFormStateUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

import Combine

final class UpdateCounterTextFormStateUC {
    /// 폼 상태 갱신
    func execute(
        text: AnyPublisher<String, Never>,
        didBeginEditing: AnyPublisher<Void, Never>,
        didEndEditing: AnyPublisher<Void, Never>,
        state: AnyPublisher<CounterTextFormState, Never>
    ) -> AnyPublisher<CounterTextFormState, Never> {
        let isEditing = Publishers.Merge(
            didBeginEditing.map { true },
            didEndEditing.map { false }
        ).eraseToAnyPublisher()
        
        return Publishers.Merge(
            text.withLatestFrom(state) { $1.updated(text: $0) },
            isEditing.withLatestFrom(state) { $1.updated(isEditing: $0) }
        )
        .map {
            $0.updated(isValid: $0.nowByte <= $0.maxByte, isEmpty: $0.text.isEmpty)
        }
        .eraseToAnyPublisher()
    }
}
