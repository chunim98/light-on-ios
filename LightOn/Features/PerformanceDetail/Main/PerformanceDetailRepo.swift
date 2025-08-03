//
//  PerformanceDetailRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/16/25.
//

import Combine

import Alamofire

protocol PerformanceDetailRepo {
    /// 공연 상세정보 조회
    func getPerformanceDetail(id: Int) -> AnyPublisher<PerformanceDetailInfo, Never>
}

// MARK: - Default

final class DefaultPerformanceDetailRepo: PerformanceDetailRepo {
    func getPerformanceDetail(id: Int) -> AnyPublisher<PerformanceDetailInfo, Never> {
        Future { promise in
            
            APIClient.plain.request(
                BaseURL + "/api/members/performances/\(id)",
                method: .get
            )
            .decodeResponse(decodeType: PerformanceDetailResDTO.self) {
                print("공연 상세정보 조회 완료")
                promise(.success($0.toDomain()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
