//
//  FreeApplyModalVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/25/25.
//

import Foundation
import Combine

final class FreeApplyModalVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        /// 신청 버튼 탭
        let confirmTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 공연 신청 완료 이벤트
        let applicationCompleteEvent: AnyPublisher<Void, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let performanceID: Int
    private let applyPerformanceUC: ApplyPerformanceUC
    
    // MARK: Initializer
    
    init(
        performanceID: Int,
        repo: ApplyPerformanceRepo
    ) {
        self.performanceID = performanceID
        self.applyPerformanceUC = .init(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 공연 신청 완료 이벤트
        let applicationCompleteEvent = applyPerformanceUC.execute(
            trigger: input.confirmTap,
            performanceID: performanceID,
            audienceCount: 1    // 아직은 1인만 지원 가능
        )
        
        return Output(applicationCompleteEvent: applicationCompleteEvent)
    }
}
