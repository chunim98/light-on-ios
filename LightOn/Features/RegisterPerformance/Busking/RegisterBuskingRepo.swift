//
//  RegisterBuskingRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import Combine

protocol RegisterBuskingRepo {
    /// 버스킹 등록 요청
    func requestRegisterBusking(info: RegisterBuskingInfo) -> AnyPublisher<Void, Never>
}

// MARK: - Default

final class DefaultRegisterBuskingRepo: RegisterBuskingRepo {
    func requestRegisterBusking(info: RegisterBuskingInfo) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            APIClient.shared.requestPost(
                endPoint: "/api/members/performances/buskings",
                parameters: RegisterBuskingReqDTO(from: info),
                decodeType: EmptyDTO.self
            ) { _ in
                print("버스킹 등록 요청 완료")
                promise(.success(()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
