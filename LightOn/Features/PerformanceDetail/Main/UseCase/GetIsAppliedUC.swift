//
//  GetIsAppliedUC.swift
//  LightOn
//
//  Created by 신정욱 on 8/29/25.
//

import Combine

final class GetIsAppliedUC {
    
    private let repo: IsAppliedRepo
    
    init(repo: IsAppliedRepo) {
        self.repo = repo
    }
    
    /// 이미 신청한 공연인지 아닌지 확인
    /// - 단 한번만 실행됨
    func execute(
        performanceID: Int,
        loginState: AnyPublisher<SessionManager.LoginState, Never>
    ) -> AnyPublisher<Bool, Never> {
        loginState
            .first()
            .compactMap { [weak self] loginState in
                loginState == .login
                ? self?.repo.getIsApplied(perfID: performanceID)
                : Just(false).eraseToAnyPublisher()
            }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
