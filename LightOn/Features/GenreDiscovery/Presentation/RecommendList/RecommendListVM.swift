//
//  RecommendListVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/16/25.
//

import Foundation
import Combine

final class RecommendListVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let refreshEvent: AnyPublisher<Void, Never>
        let selectedPerformanceID: AnyPublisher<Int, Never>
    }
    struct Output {
        /// 최신 or 추천 공연 배열들
        let recentRecommendeds: AnyPublisher<[HashtagPerformanceCellItem], Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let getPerformancesUC: GetHashtagPerformancesUC
    
    // MARK: Initializer
    
    init(repo: any GenreDiscoveryRepo) {
        self.getPerformancesUC = GetHashtagPerformancesUC(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 로그인 상태
        let loginState = SessionManager.shared.loginStatePublisher
            .eraseToAnyPublisher()
        
        /// 최신 or 추천 공연 배열들
        let recentRecommendeds = getPerformancesUC.getRecentRecommendeds(
            trigger: input.refreshEvent,
            loginState: loginState
        )
        
        // 선택한 공연의 상세 페이지로 이동
        input.selectedPerformanceID
            .sink {
                AppCoordinatorBus.shared.navigationEventSubject
                    .send(.performanceDetail(id: $0))
            }
            .store(in: &cancellables)
        
        return Output(recentRecommendeds: recentRecommendeds)
    }
}
