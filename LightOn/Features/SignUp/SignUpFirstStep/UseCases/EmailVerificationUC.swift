//
//  EmailVerificationUC.swift
//  LightOn
//
//  Created by 신정욱 on 6/3/25.
//

import Combine

final class EmailVerificationUC {
    
    private let repository: DuplicationStateRepo
    
    init(repository: DuplicationStateRepo) {
        self.repository = repository
    }
    
    /// 이메일 형식 검사
    func checkFormat(
        _ rootEmailState: AnyPublisher<EmailState, Never>
    ) -> AnyPublisher<EmailState, Never> {
        
        rootEmailState.map {
            let regex = /^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$/
            let isFormatChecked = $0.text.wholeMatch(of: regex) != nil
            
            return $0.updated(
                isFormatChecked: isFormatChecked,
                duplicationState: .unchecked // 텍스트 수정하면, 중복 검사 무효화
            )
        }
        .eraseToAnyPublisher()
    }
    
    /// 이메일 중복 검사
    func checkDuplication(
        _ buttonTap: AnyPublisher<Void, Never>,
        _ emailState: AnyPublisher<EmailState, Never>
    ) -> AnyPublisher<EmailState, Never> {
        
        buttonTap
            .withLatestFrom(emailState) { _, emailState in emailState }
            .compactMap { [weak self] emailState in
                self?.repository
                    .getDuplicationState(emailText: emailState.text)
                    .map { emailState.updated(duplicationState: $0) }
                    .eraseToAnyPublisher()
            }
            .flatMap { $0 }
            .eraseToAnyPublisher()
    }
}
