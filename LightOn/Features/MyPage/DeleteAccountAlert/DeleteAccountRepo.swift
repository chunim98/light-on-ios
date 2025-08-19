//
//  DeleteAccountRepo.swift
//  LightOn
//
//  Created by 신정욱 on 8/19/25.
//

import Combine

import Alamofire

protocol DeleteAccountRepo {
    /// 서버에 회원 탈퇴 요청
    func requestDeleteAccount() -> AnyPublisher<Void, Never>
}

// MARK: Default

final class DefaultDeleteAccountRepo: DeleteAccountRepo {
    func requestDeleteAccount() -> AnyPublisher<Void, Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/auth/me",
                method: .delete
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                print("[DeleteAccountRepo] 회원 탈퇴 완료")
                promise(.success(()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
