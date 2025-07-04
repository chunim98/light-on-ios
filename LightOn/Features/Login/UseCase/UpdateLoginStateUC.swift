//
//  UpdateLoginStateUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

import Combine

final class UpdateLoginStateUC {
    /// 로그인 필드 상태 갱신
    func execute(
        email: AnyPublisher<String, Never>,
        pw: AnyPublisher<String, Never>,
        loginState: AnyPublisher<LoginState, Never>
    ) -> AnyPublisher<LoginState, Never> {
        Publishers.Merge(
            email.withLatestFrom(loginState) { $1.updated(email: $0) },
            pw.withLatestFrom(loginState) { $1.updated(pw: $0) }
        )
        .eraseToAnyPublisher()
    }
}
