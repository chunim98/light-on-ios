//
//  PerformanceDetailVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/16/25.
//

import Foundation
import Combine

final class PerformanceDetailVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let applyTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 공연 상세 정보
        let detailInfo: AnyPublisher<PerformanceDetailInfo, Never>
        /// 공연 신청 이벤트(유료 공연 여부 포함)
        let applyEventWithIsPaid: AnyPublisher<Bool, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let performanceID: Int
    private let performanceDetailRepo: PerformanceDetailRepo
    
    // MARK: Initializer
    
    init(performanceID: Int, repo: any PerformanceDetailRepo) {
        self.performanceID = performanceID
        self.performanceDetailRepo = repo
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 공연 상세 정보
        let detailInfo = performanceDetailRepo
            .getPerformanceDetail(id: performanceID)
            .share()
            .eraseToAnyPublisher()
        
        /// 공연 신청 이벤트(유료 공연 여부 포함)
        let applyEventWithIsPaid = input.applyTap
            .withLatestFrom(detailInfo) { _, info in info.isPaid }
            .eraseToAnyPublisher()
        
        return Output(
            detailInfo: detailInfo,
            applyEventWithIsPaid: applyEventWithIsPaid
        )
    }
}
