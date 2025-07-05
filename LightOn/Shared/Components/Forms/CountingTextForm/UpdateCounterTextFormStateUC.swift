//
//  UpdateCounterTextFormStateUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/5/25.
//

import Combine

final class UpdateCounterTextFormStateUC {
    
    // MARK: Properties
    
    private let maxByte: Int
    
    // MARK: Initializer
    
    init(maxByte: Int) {
        self.maxByte = maxByte
    }
    
    // MARK: Methods
    
    /// 폼 상태 갱신
    func execute(
        text: AnyPublisher<String, Never>,
        didBeginEditing: AnyPublisher<Void, Never>,
        didEndEditing: AnyPublisher<Void, Never>,
        state: AnyPublisher<CounterTextFormState, Never>
    ) -> AnyPublisher<CounterTextFormState, Never> {
        Publishers.Merge3(
            text.withLatestFrom(state) {
                $1.updated(text: $0, byte: $0.count)
            },
            didBeginEditing.withLatestFrom(state) { _, state in
                state.updated(isEditing: true)
            },
            didEndEditing.withLatestFrom(state) { _, state in
                state.updated(isEditing: false)
            }
        )
        .map { state in
            state.updated(style: { [maxByte = self.maxByte] in
                state.isEditing ?
                (state.byte <= maxByte ? .focused : .invalid) :
                (state.byte == 0 ? .empty : (state.byte <= maxByte ? .filled : .invalid))
            }())
        }
        .eraseToAnyPublisher()
    }
}
