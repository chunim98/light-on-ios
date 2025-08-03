//
//  LoginRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

import Combine

import Alamofire

protocol LoginRepo {
    /// 서버에 로그인 요청
    func postLoginState(state: LoginState) -> AnyPublisher<UserToken, Never>
}

// MARK: - Default

final class DefaultLoginRepo: LoginRepo {
    func postLoginState(state: LoginState) -> AnyPublisher<UserToken, Never> {
        Future { promise in
            
            APIClient.plain.request(
                BaseURL + "/api/auth/login",
                method: .post,
                parameters: LoginRequestDTO(from: state),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: TokenResponseDTO.self) {
                print("로그인 완료")
                promise(.success($0.toDomain()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
