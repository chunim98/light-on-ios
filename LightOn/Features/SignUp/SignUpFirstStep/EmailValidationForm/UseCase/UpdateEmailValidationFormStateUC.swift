//
//  UpdateEmailValidationFormStateUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

import Combine

final class UpdateEmailValidationFormStateUC {
    /// 이메일 폼 상태 갱신
    func execute(
        email: AnyPublisher<String, Never>,
        duplication: AnyPublisher<EmailValidationFormState.Duplication, Never>,
        emailFormat: AnyPublisher<EmailValidationFormState.Format, Never>,
        state: AnyPublisher<EmailValidationFormState, Never>
    ) -> AnyPublisher<EmailValidationFormState, Never> {
        Publishers.Merge3(
            email.withLatestFrom(state) { $1.updated(email: $0, duplication: .unknown) },
            duplication.withLatestFrom(state) { $1.updated(duplication: $0) },
            emailFormat.withLatestFrom(state) { $1.updated(format: $0) }
        )
        .eraseToAnyPublisher()
    }
}
