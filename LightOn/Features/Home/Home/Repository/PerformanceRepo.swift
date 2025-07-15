//
//  PerformanceRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import Combine

protocol PerformanceRepo {
    /// 인기공연 조회
    func requestPopular() -> AnyPublisher<[PopularCellItem], Never>
    /// 추천공연 조회
    func requestRecommended() -> AnyPublisher<[RecommendCellItem], Never>
}

// MARK: - Default

final class DefaultPerformanceRepo: PerformanceRepo {
    func requestPopular() -> AnyPublisher<[PopularCellItem], Never> {
        Future { promise in
            
            APIClient.shared.requestGet(
                endPoint: "/api/members/performances/popular",
                tokenIncluded: false,
                decodeType: PerformancesResDTO.self
            ) {
                print("인기공연 조회 완료")
                promise(.success($0.performances.map { $0.toPopular() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func requestRecommended() -> AnyPublisher<[RecommendCellItem], Never> {
        Future { promise in
            
            APIClient.shared.requestGet(
                endPoint: "/api/members/performances/popular",
                tokenIncluded: false,
                decodeType: PerformancesResDTO.self
            ) {
                print("추천공연 조회 완료")
                promise(.success($0.performances.map { $0.toRecommend() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
