//
//  IsAppliedRepo.swift
//  LightOn
//
//  Created by 신정욱 on 8/29/25.
//

import Combine

import Alamofire

protocol IsAppliedRepo {
    /// 이미 신청한 공연인지 아닌지 조회
    func getIsApplied(perfID: Int) -> AnyPublisher<Bool, Never>
}

// MARK: Default

final class DefaultIsAppliedRepo: IsAppliedRepo {
    func getIsApplied(perfID: Int) -> AnyPublisher<Bool, Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/members/performances/\(perfID)/applied",
                method: .get
            )
            .decodeResponse(decodeType: IsAppliedResDTO.self) {
                print("[IsAppliedRepo] 이미 신청한 공연인지 조회 완료")
                promise(.success($0.isApplied))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
