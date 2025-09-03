//
//  DetermineLikeButtonModeUC.swift
//  LightOn
//
//  Created by 신정욱 on 9/3/25.
//

import Combine

final class DetermineLikeButtonModeUC {
    /// 좋아요 버튼의 모드를 결정
    func execute(
        loginState: AnyPublisher<SessionManager.LoginState, Never>
    ) -> AnyPublisher<LikeButtonMode, Never> {
        loginState
            .map { $0 == .login ? .toggle : .login }
            .eraseToAnyPublisher()
    }
}
