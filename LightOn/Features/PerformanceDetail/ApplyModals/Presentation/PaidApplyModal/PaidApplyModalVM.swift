//
//  PaidApplyModalVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/24/25.
//

import Foundation
import Combine

final class PaidApplyModalVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        /// 최종 신청 버튼 탭
        let confirmTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 지불 정보
        let paymentInfo: AnyPublisher<PaymentInfo, Never>
        /// 공연 신청 완료 이벤트
        let applicationCompleteEvent: AnyPublisher<Void, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let performanceID: Int
    private let audienceCount: Int
    private let applyPerformanceRepo: ApplyPerformanceRepo
    private let applyPerformanceUC: ApplyPerformanceUC
    
    // MARK: Initializer
    
    init(
        performanceID: Int,
        audienceCount: Int,
        repo: ApplyPerformanceRepo
    ) {
        self.performanceID = performanceID
        self.audienceCount = audienceCount
        self.applyPerformanceRepo = repo
        self.applyPerformanceUC = .init(repo: repo)
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
        
        let applicationCompleteEvent = applyPerformanceUC.execute(
            trigger: input.confirmTap,
            performanceID: performanceID,
            audienceCount: audienceCount
        )
        
        return Output(
            paymentInfo: paymentInfo,
            applicationCompleteEvent: applicationCompleteEvent
        )
    }
}
