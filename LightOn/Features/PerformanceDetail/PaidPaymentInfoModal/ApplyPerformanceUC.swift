//
//  ApplyPerformanceUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/25/25.
//

import Combine

final class ApplyPerformanceUC {
    
    private let repo: ApplyPaidPerformanceRepo
    
    init(repo: ApplyPaidPerformanceRepo) {
        self.repo = repo
    }
    
    /// 공연 관람 신청
    func execute(
        trigger: AnyPublisher<Void, Never>,
        performanceID: Int,
        audienceCount: Int
    ) -> AnyPublisher<Void, Never> {
        trigger.compactMap { [weak self] in
            self?.repo.requestApplyPerformance(
                performanceID: performanceID,
                audienceCount: audienceCount
            )
        }
        .switchToLatest()
        .share()
        .eraseToAnyPublisher()
    }
}
