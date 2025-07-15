//
//  GenreDiscoveryRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import Combine

protocol GenreDiscoveryRepo {
    /// 인기공연 조회
    func requestPopular() -> AnyPublisher<[HashtagPerformanceCellItem], Never>
    /// 추천공연 조회
    func requestRecommended() -> AnyPublisher<[HashtagPerformanceCellItem], Never>
}

// MARK: - Default

final class DefaultGenreDiscoveryRepo: GenreDiscoveryRepo {
    func requestPopular() -> AnyPublisher<[HashtagPerformanceCellItem], Never> {
        Future { promise in
            
            APIClient.shared.requestGet(
                endPoint: "/api/members/performances/popular",
                tokenIncluded: false,
                decodeType: PerformancesResDTO.self // Home의 DTO 재사용
            ) {
                print("인기공연 조회 완료")
                promise(.success($0.performances.map { $0.toHashtag() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func requestRecommended() -> AnyPublisher<[HashtagPerformanceCellItem], Never> {
        Future { promise in
            
            APIClient.shared.requestGet(
                endPoint: "/api/members/performances/recommend",
                tokenIncluded: false,
                decodeType: PerformancesResDTO.self // Home의 DTO 재사용
            ) {
                print("추천공연 조회 완료")
                promise(.success($0.performances.map { $0.toHashtag() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
