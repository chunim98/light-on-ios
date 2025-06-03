//
//  ButtonEnabledUC.swift
//  LightOn
//
//  Created by 신정욱 on 6/2/25.
//

import Combine

final class ButtonEnabledUC {
    
    func getDuplicationButtonEnabled(
        _ emailState: AnyPublisher<EmailState, Never>,
        _ duplicationTap: AnyPublisher<Void, Never>
    ) -> AnyPublisher<Bool, Never> {
        
        let isDuplicationButtonEnabled1 = emailState
            .map { $0.isFormatChecked || ($0.duplicationState != .unchecked) }
            .eraseToAnyPublisher()
        
        let isDuplicationButtonEnabled2 = duplicationTap
            .map { _ in false }
            .eraseToAnyPublisher()
        
        return Publishers.Merge(
            isDuplicationButtonEnabled1,
            isDuplicationButtonEnabled2
        )
        .eraseToAnyPublisher()
    }
    
    func getNextButtonEnabled(
        _ emailState: AnyPublisher<EmailState, Never>,
        _ pwState: AnyPublisher<PWState, Never>
    ) -> AnyPublisher<Bool, Never> {
        
        Publishers.CombineLatest(emailState, pwState)
            .map { emailState, pwState in
                
                let isValidEmail = emailState.isFormatChecked &&
                (emailState.duplicationState == .verified)
                
                let isValidPW = pwState.isFormatChecked &&
                (pwState.text == pwState.confirmText)
                
                return isValidEmail && isValidPW
            }
            .eraseToAnyPublisher()
    }
}
