//
//  AuthCodeRepository.swift
//  LightOn
//
//  Created by 신정욱 on 6/29/25.
//

import Combine

protocol AuthCodeRepository {
    /// 인증코드 문자 발송 요청
    func requestAuthCodeSMS(state: PhoneNumberFormState) -> AnyPublisher<Void, Never>
}

// MARK: - Default

final class DefaultAuthCodeRepository: AuthCodeRepository {
    func requestAuthCodeSMS(state: PhoneNumberFormState) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            APIClient.shared.requestPost(
                endPoint: "/api/auth/phones/code",
                parameters: AuthCodeRequestDTO(from: state),
                tokenIncluded: false,
                decodeType: EmptyDTO.self
            ) { _ in
                print("인증코드 문자 발송 요청 완료")
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
}
