//
//  GetPaymentInfoUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/25/25.
//

import Combine

final class GetPaymentInfoUC {
    
    private let repo: ApplyPerformanceRepo
    
    init(repo: ApplyPerformanceRepo) {
        self.repo = repo
    }
    
    /// 지불 정보 요청
    func execute(
        performanceID: Int,
        audienceCount: Int
    ) -> AnyPublisher<PaymentInfo, Never> {
        repo.getPaymentInfo(
            performanceID: performanceID,
            audienceCount: audienceCount
        )
        .share()
        .eraseToAnyPublisher()
    }
}
