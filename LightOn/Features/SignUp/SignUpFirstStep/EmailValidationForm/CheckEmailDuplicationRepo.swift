//
//  CheckEmailDuplicationRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

import Combine

protocol CheckEmailDuplicationRepo {
    /// 이메일 중복 확인 요청
    func checkEmailDuplication(
        email: String
    ) -> AnyPublisher<EmailValidationFormState.Duplication, Never>
}

// MARK: - Default

final class DefaultCheckEmailDuplicationRepo: CheckEmailDuplicationRepo {
    func checkEmailDuplication(
        email: String
    ) -> AnyPublisher<EmailValidationFormState.Duplication, Never> {
        Future { promise in
            
            APIClient.shared.requestGet(
                endPoint: "/api/members/duplicate-check",
                parameters: ["email": email],
                tokenIncluded: false,
                decodeType: EmailDuplicationResponseDTO.self
            ) {
                print("이메일 중복확인 요청 성공")
                promise(.success($0.toDomain()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
