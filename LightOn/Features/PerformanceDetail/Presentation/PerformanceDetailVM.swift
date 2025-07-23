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
        /// 공연 신청 이벤트
        let applyEvent: AnyPublisher<PerformanceDetailInfo, Never>
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
        let detailInfo = performanceDetailRepo
            .getPerformanceDetail(id: performanceID)
            .share()
            .eraseToAnyPublisher()
        
        let applyEvent = input.applyTap
            .withLatestFrom(detailInfo) { _, info in info }
            .eraseToAnyPublisher()
        
        return Output(detailInfo: detailInfo, applyEvent: applyEvent)
    }
}
