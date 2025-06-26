//
//  MakeRootStateUC.swift
//  LightOn
//
//  Created by 신정욱 on 6/3/25.
//

import Combine

final class MakeRootStateUC {
    
    func makeEmailState(
        _ emailText: AnyPublisher<String, Never>
    ) -> AnyPublisher<EmailState, Never> {
        
        emailText
            .map { EmailState(text: $0) }
            .eraseToAnyPublisher()
    }
    
    func makePWState(
        _ pwText: AnyPublisher<String, Never>,
        _ confirmText: AnyPublisher<String, Never>
    ) -> AnyPublisher<PWState, Never> {
        
        Publishers
            .CombineLatest(pwText, confirmText)
            .map { PWState(text: $0, confirmText: $1) }
            .eraseToAnyPublisher()
    }
}
