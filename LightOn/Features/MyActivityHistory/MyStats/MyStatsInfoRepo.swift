//
//  MyStatsInfoRepo.swift
//  LightOn
//
//  Created by 신정욱 on 8/8/25.
//

import Combine

import Alamofire

protocol MyStatsInfoRepo {
    /// 내 활동 통계 조회
    func getMyStatsInfo() -> AnyPublisher<MyStatsInfo, Never>
}

// MARK: Default

final class DefaultMyStatsInfoRepo: MyStatsInfoRepo {
    func getMyStatsInfo() -> AnyPublisher<MyStatsInfo, Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/members/performances/my-page/stats",
                method: .get
            )
            .decodeResponse(decodeType: MyStatsResDTO.self) {
                print("[MyStatsInfoRepo] 내 활동 통계 조회 완료")
                promise(.success($0.toDomain()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}

