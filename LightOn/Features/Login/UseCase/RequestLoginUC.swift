//
//  RequestLoginUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

import Combine

final class RequestLoginUC {
    
    private let repo: LoginRepo
    
    init(repo: LoginRepo) {
        self.repo = repo
    }
    
    /// 서버에 로그인 요청
    func execute(
        trigger: AnyPublisher<Void, Never>,
        loginState: AnyPublisher<LoginState, Never>
    ) -> AnyPublisher<UserToken, Never> {
        trigger
            .withLatestFrom(loginState) { _, state in state }
            .compactMap { [weak self] in self?.repo.postLoginState(state: $0) }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
