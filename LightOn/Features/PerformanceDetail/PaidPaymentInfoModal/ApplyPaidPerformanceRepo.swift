//
//  ApplyPaidPerformanceRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/24/25.
//

import Combine

protocol ApplyPaidPerformanceRepo {
    /// 결제 정보 요청
    func getPaymentInfo(
        performanceID: Int,
        audienceCount: Int
    ) -> AnyPublisher<PaymentInfo, Never>
}

// MARK: - Default

final class DefaultApplyPaidPerformanceRepo: ApplyPaidPerformanceRepo {
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
}
