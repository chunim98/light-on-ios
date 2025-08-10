//
//  UpdateMyPageStateUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

import Combine

final class UpdateMyPageStateUC {
    /// 로그인 상태 기반, 마이페이지 상태 갱신
    func execute() -> AnyPublisher<MyPageState, Never> {
        SessionManager.shared.$loginState.map { state in
            switch state {
            case .unknown, .logout: return .logout
            case .login:            return .login
            }
        }
        .eraseToAnyPublisher()
    }
}
