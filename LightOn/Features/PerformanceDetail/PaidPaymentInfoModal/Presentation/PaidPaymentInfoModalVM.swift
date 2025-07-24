//
//  PaidPaymentInfoModalVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/24/25.
//

import Foundation
import Combine

final class PaidPaymentInfoModalVM {
    
    // MARK: Input & Ouput
    
    struct Input {}
    struct Output {
        /// 지불 정보
        let paymentInfo: AnyPublisher<PaymentInfo, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let performanceID: Int
    private let audienceCount: Int
    private let applyPerformanceRepo: ApplyPaidPerformanceRepo
    
    // MARK: Initializer
    
    init(
        performanceID: Int,
        audienceCount: Int,
        repo: ApplyPaidPerformanceRepo
    ) {
        self.performanceID = performanceID
        self.audienceCount = audienceCount
        self.applyPerformanceRepo = repo
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 지불 정보
        let paymentInfo = applyPerformanceRepo
            .getPaymentInfo(
                performanceID: performanceID,
                audienceCount: audienceCount
            )
            .share()
            .eraseToAnyPublisher()
        
        return Output(paymentInfo: paymentInfo)
    }
}
