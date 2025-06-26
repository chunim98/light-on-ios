//
//  DefaultDuplicationStateRepository.swift
//  LightOn
//
//  Created by 신정욱 on 6/2/25.
//

import Combine

final class DefaultDuplicationStateRepository: DuplicationStateRepository {
    
    func getDuplicationState(emailText: String) -> AnyPublisher<DuplicationState, Never> {
        Future { promise in
            
            APIClient.shared.requestGet(
                endPoint: "/api/members/duplicate-check",
                parameters: ["email": emailText],
                tokenIncluded: false,
                decodeType: DuplicationStateResponseDTO.self
            ) {
                print("이메일 중복확인 요청 성공")
                promise(.success($0.toDomain()))
            }
        }
        .eraseToAnyPublisher()
    }
}

