//
//  PerformanceBannerRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/23/25.
//

import Combine

protocol PerformanceBannerRepo {
    /// 배너 공연 조회
    func requestBanner() -> AnyPublisher<[PerformanceBannerItem], Never>
}

// MARK: - Default

final class DefaultPerformanceBannerRepo: PerformanceBannerRepo {
    func requestBanner() -> AnyPublisher<[PerformanceBannerItem], Never> {
        Future { promise in
            
            APIClient.shared.requestGet(
                endPoint: "/api/members/advertisements",
                parameters: ["position": "MAIN"],
                tokenIncluded: false,
                decodeType: PerformanceBannerResDTO.self
            ) {
                print("배너 공연 조회 완료")
                promise(.success($0.advertisements.map { $0.toDomain() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
}

