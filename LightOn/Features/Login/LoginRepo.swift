//
//  LoginRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

import Combine

protocol LoginRepo {
    /// 서버에 로그인 요청
    func postLoginState(state: LoginState) -> AnyPublisher<UserToken, Never>
}

// MARK: - Default

final class DefaultLoginRepo: LoginRepo {
    func postLoginState(state: LoginState) -> AnyPublisher<UserToken, Never> {
        Future { promise in
            
            print(state.email, state.pw)
            
            APIClient.shared.requestPost(
                endPoint: "/api/auth/login",
                parameters: LoginRequestDTO(from: state),
                tokenIncluded: false,
                decodeType: TokenResponseDTO.self
            ) {
                print("로그인 완료")
                promise(.success($0.toDomain()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
