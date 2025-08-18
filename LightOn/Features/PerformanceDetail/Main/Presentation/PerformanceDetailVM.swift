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
        /// 로그인 상태
        let loginState = SessionManager.shared.loginStatePublisher
        
        /// 공연 상세 정보
        let detailInfo = performanceDetailRepo
            .getPerformanceDetail(id: performanceID)
            .share()
            .eraseToAnyPublisher()
        
        /// 로그인 상태가 아니라면, 먼저 로그인 화면으로 보내도록 필터링
        let filteredApplyTap = input.applyTap
            .withLatestFrom(loginState) { _, state in state }
            .filter {
                guard !($0 == .login) else { return true }
                AppCoordinatorBus.shared.navigationEventSubject.send(.login)
                return false
            }
            .eraseToAnyPublisher()
        
        /// 공연 신청 이벤트(유료 공연 여부 포함)
        let applyEventWithIsPaid = filteredApplyTap
            .withLatestFrom(detailInfo) { _, info in info.isPaid }
            .eraseToAnyPublisher()
        
        return Output(
            detailInfo: detailInfo,
            applyEventWithIsPaid: applyEventWithIsPaid
        )
    }
}
