//
//  ApplyPerformanceRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/24/25.
//

import Combine

import Alamofire

protocol ApplyPerformanceRepo {
    /// 결제 정보 요청
    func getPaymentInfo(
        performanceID: Int,
        audienceCount: Int
    ) -> AnyPublisher<PaymentInfo, Never>
    
    /// 공연 관람 신청
    func requestApplyPerformance(
        performanceID: Int,
        audienceCount: Int
    ) -> AnyPublisher<Void, Never>
}

// MARK: - Default

final class DefaultApplyPerformanceRepo: ApplyPerformanceRepo {
    func getPaymentInfo(
        performanceID: Int,
        audienceCount: Int
    ) -> AnyPublisher<PaymentInfo, Never> {
        Future { promise in
            
            APIClient.shared.requestGet(
                endPoint: "/api/members/performances/\(performanceID)/payment",
                parameters: ["applySeats": audienceCount],
                decodeType: PaymentInfoResDTO.self
            ) {
                print("결제 정보 조회 완료")
                promise(.success($0.toDomain()))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func requestApplyPerformance(
        performanceID: Int,
        audienceCount: Int
    ) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            let rootURL = APIConstants.lightOnRootURL
            let endPoint = "/api/members/performances/\(performanceID)/request"
            
            let request = AF.request(
                rootURL + endPoint,
                method: .post,
                parameters: ["applySeats": audienceCount],
                encoding: URLEncoding.queryString,  // 이렇게 설정하면, POST인데도 항상 URL 뒤에 붙여 줌
                headers: nil,
                interceptor: APITokenInterceptor()
            )
            
            APIClient.shared.decodeResponse(
                request: request,
                decodeType: EmptyDTO.self
            ) { _ in
                print("공연 관람 신청 완료")
                promise(.success(()))
                
            } errorHandler: {
                print("공연 관람 신청 실패:", $0.message)
            }
            
        }
        .eraseToAnyPublisher()
    }
}
