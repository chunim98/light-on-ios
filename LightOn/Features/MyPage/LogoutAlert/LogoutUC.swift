//
//  LogoutUC.swift
//  LightOn
//
//  Created by 신정욱 on 8/19/25.
//

import Combine

final class LogoutUC {
    
    private let repo: LogoutRepo
    
    init(repo: LogoutRepo) {
        self.repo = repo
    }
    
    /// 서버에 로그아웃 요청
    func requestLogout(
        trigger: AnyPublisher<Void, Never>
    ) -> AnyPublisher<Void, Never> {
        trigger
            .compactMap { [weak self] in self?.repo.requestLogout() }
            .switchToLatest()
            .handleEvents(receiveOutput: {
                TokenKeychain.shared.delete(.access)
                TokenKeychain.shared.delete(.refresh)
                TokenKeychain.shared.delete(.fcm)
                SessionManager.shared.updateLoginState()
            })
            .share()
            .eraseToAnyPublisher()
    }
}
