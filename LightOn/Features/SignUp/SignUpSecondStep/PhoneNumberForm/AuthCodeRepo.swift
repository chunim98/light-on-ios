//
//  AuthCodeRepo.swift
//  LightOn
//
//  Created by 신정욱 on 6/29/25.
//

import Combine

import Alamofire

protocol AuthCodeRepo {
    /// 인증코드 문자 발송 요청
    func requestAuthCodeSMS(state: PhoneNumberFormState) -> AnyPublisher<Void, Never>
    /// 휴대폰 번호 최종 인증 요청
    func postAuthCode(state: PhoneNumberFormState) -> AnyPublisher<Void, Never>
}

// MARK: - Default

final class DefaultAuthCodeRepo: AuthCodeRepo {
    func requestAuthCodeSMS(state: PhoneNumberFormState) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            APIClient.plain.request(
                BaseURL + "/api/auth/phones/code",
                method: .post,
                parameters: AuthCodeRequestDTO(from: state),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                print("인증코드 문자 발송 요청 완료")
                promise(.success(()))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func postAuthCode(state: PhoneNumberFormState) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            APIClient.plain.request(
                BaseURL + "/api/auth/phones/code/verify",
                method: .post,
                parameters: PhoneNumberVerificationRequestDTO(from: state),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                print("휴대폰 번호 최종 인증 완료")
                promise(.success(()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
