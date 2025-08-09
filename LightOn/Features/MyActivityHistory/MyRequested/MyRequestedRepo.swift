//
//  MyRequestedRepo.swift
//  LightOn
//
//  Created by 신정욱 on 8/9/25.
//

import Alamofire

import Combine

protocol MyRequestedRepo {
    /// 내 공연 신청 or 등록 내역 조회
    func getMyRequested() -> AnyPublisher<[MyPerformanceCellItem], Never>
}

// MARK: Applications

final class MyApplicationsRepo: MyRequestedRepo {
    func getMyRequested() -> AnyPublisher<[MyPerformanceCellItem], Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/members/performances/my-page/requested",
                method: .get
            )
            .decodeResponse(decodeType: MyApplicationResDTO.self) {
                print("[MyRequestedRepo] 내 공연 관람 신청 내역 조회 완료")
                promise(.success($0.performanceList.map { $0.toDomain() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
}

// MARK: Registrations

final class MyRegistrationsRepo: MyRequestedRepo {
    func getMyRequested() -> AnyPublisher<[MyPerformanceCellItem], Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/members/performances/my-page/registered",
                method: .get
            )
            .decodeResponse(decodeType: MyRegisteredResDTO.self) {
                print("[MyRequestedRepo] 내 공연 등록 신청 내역 조회 완료")
                promise(.success($0.performanceList.map { $0.toDomain() }))
            }
            
        }
        .eraseToAnyPublisher()
        
    }
}

