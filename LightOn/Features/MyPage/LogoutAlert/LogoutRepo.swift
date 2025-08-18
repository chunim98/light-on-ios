//
//  LogoutRepo.swift
//  LightOn
//
//  Created by 신정욱 on 8/19/25.
//

import Combine

import Alamofire

protocol LogoutRepo {
    /// 서버에 로그아웃 요청
    func requestLogout() -> AnyPublisher<Void, Never>
}

// MARK: Default

final class DefaultLogoutRepo: LogoutRepo {
    func requestLogout() -> AnyPublisher<Void, Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/auth/logout",
                method: .post
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                print("[LogoutRepo] 로그아웃 완료")
                promise(.success(()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
