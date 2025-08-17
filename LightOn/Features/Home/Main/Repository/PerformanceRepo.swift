//
//  PerformanceRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import Combine

import Alamofire

protocol PerformanceRepo {
    /// 인기공연 조회
    func requestPopular() -> AnyPublisher<[LargePerformanceCellItem], Never>
    /// 추천공연 조회
    func requestRecommended() -> AnyPublisher<[SmallPerformanceCellItem], Never>
    /// 최신공연 조회
    func requestRecent() -> AnyPublisher<[SmallPerformanceCellItem], Never>
    /// 주목받은 아티스트 공연 조회
    func requestSpotlighted() -> AnyPublisher<[MediumPerformanceCellItem], Never>
}

// MARK: - Default

final class DefaultPerformanceRepo: PerformanceRepo {
    func requestPopular() -> AnyPublisher<[LargePerformanceCellItem], Never> {
        Future { promise in
            
            APIClient.plain.request(
                BaseURL + "/api/members/performances/popular",
                method: .get
            )
            .decodeResponse(decodeType: PerformancesResDTO.self) {
                print("인기공연 조회 완료")
                promise(.success($0.performances.map { $0.toLarge() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func requestRecommended() -> AnyPublisher<[SmallPerformanceCellItem], Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/members/performances/recommend",
                method: .get
            )
            .decodeResponse(decodeType: PerformancesResDTO.self) {
                print("추천공연 조회 완료")
                promise(.success($0.performances.map { $0.toSmall() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func requestRecent() -> AnyPublisher<[SmallPerformanceCellItem], Never> {
        Future { promise in
            
            APIClient.plain.request(
                BaseURL + "/api/members/performances/recent",
                method: .get
            )
            .decodeResponse(decodeType: PerformancesResDTO.self) {
                print("최신공연 조회 완료")
                promise(.success($0.performances.map { $0.toSmall() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func requestSpotlighted() -> AnyPublisher<[MediumPerformanceCellItem], Never> {
        Future { promise in
            
            APIClient.plain.request(
                BaseURL + "/api/members/performances/trending",
                method: .get
            )
            .decodeResponse(decodeType: PerformancesResDTO.self) {
                print("주목받은 아티스트 공연 조회 완료")
                promise(.success($0.performances.map { $0.toMedium() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
