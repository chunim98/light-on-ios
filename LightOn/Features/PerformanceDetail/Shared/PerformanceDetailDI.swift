//
//  PerformanceDetailDI.swift
//  LightOn
//
//  Created by 신정욱 on 7/16/25.
//

final class PerformanceDetailDI {
    
    // MARK: Singleton
    
    static let shared = PerformanceDetailDI()
    private init() {}
    
    // MARK: Methods
    
    func makePerformanceDetailVM(performanceID: Int) -> PerformanceDetailVM {
        PerformanceDetailVM(
            performanceID: performanceID,
            repo: DefaultPerformanceDetailRepo()
        )
    }
    
    func makePaidApplyModalVM(
        performanceID: Int,
        audienceCount: Int
    ) -> PaidApplyModalVM {
        PaidApplyModalVM(
            performanceID: performanceID,
            audienceCount: audienceCount,
            repo: DefaultApplyPerformanceRepo()
        )
    }
}
