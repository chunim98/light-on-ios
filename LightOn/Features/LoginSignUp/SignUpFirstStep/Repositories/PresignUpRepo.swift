//
//  PresignUpRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/2/25.
//

import Combine

protocol PresignUpRepo {
    /// 임시 회원가입 요청 (임시 회원 번호 발급)
    func postEmailPW(email: String, pw: String) -> AnyPublisher<Int, Never>
}

// MARK: - Default

final class DefaultPresignUpRepo: PresignUpRepo {
    func postEmailPW(email: String, pw: String) -> AnyPublisher<Int, Never> {
        Future { promise in
            
            APIClient.shared.requestPost(
                endPoint: "/api/members",
                parameters: PresignUpRequestDTO(email: email, password: pw),
                decodeType: PresignUpResponseDTO.self
            ) {
                print("임시 회원가입 요청 성공")
                promise(.success($0.temporaryUserId))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
