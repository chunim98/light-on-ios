//
//  HomeVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import Foundation
import Combine

final class HomeVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let refreshEvent: AnyPublisher<Void, Never>
        let selectedPerformanceID: AnyPublisher<Int, Never>
    }
    struct Output {
        /// 공연 배너 배열들
        let banners: AnyPublisher<[PerformanceBannerItem], Never>
        /// 인기 공연 배열들
        let populars: AnyPublisher<[LargePerformanceCellItem], Never>
        /// 주목받은 아티스트 공연 배열들
        let spotlighteds: AnyPublisher<[MediumPerformanceCellItem], Never>
        /// 최신 or 추천 공연 배열들
        let recentRecommendeds: AnyPublisher<[SmallPerformanceCellItem], Never>
        /// 최신, 추천 공연 헤더 타이틀
        let recentRecommendedTitle: AnyPublisher<String, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let getPerformanceBannerUC: GetPerformanceBannerUC
    private let getPerformancesUC: GetPerformancesUC
    
    // MARK: Initializer
    
    init(
        bannerRepo: any PerformanceBannerRepo,
        perfRepo: any PerformanceRepo
    ) {
        self.getPerformanceBannerUC = .init(repo: bannerRepo)
        self.getPerformancesUC = .init(repo: perfRepo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 로그인 상태
        let loginState = SessionManager.shared.loginStatePublisher
            .filter { $0 != .unknown }
            .eraseToAnyPublisher()
        
        /// 공연 배너 배열들
        let banners = getPerformanceBannerUC.execute()
        
        /// 인기 공연 배열들
        let populars = getPerformancesUC.getPopulars(
            trigger: input.refreshEvent
        )
        
        /// 주목받은 아티스트 공연 배열들
        let spotlighteds = getPerformancesUC.getSpotlighted(
            trigger: input.refreshEvent
        )
        
        /// 최신 or 추천 공연 배열들
        let recentRecommendeds = getPerformancesUC.getRecentRecommendeds(
            trigger: input.refreshEvent,
            loginState: loginState
        )
        
        /// 최신, 추천 공연 헤더 타이틀
        let recentRecommendedTitle = loginState
            .map { $0 == .login ? "추천 공연" : "최신 공연" }
            .eraseToAnyPublisher()
        
        // 선택한 공연의 상세 페이지로 이동
        input.selectedPerformanceID
            .sink {
                AppCoordinatorBus.shared.navigationEventSubject
                    .send(.performanceDetail(id: $0))
            }
            .store(in: &cancellables)
        
        return Output(
            banners: banners,
            populars: populars,
            spotlighteds: spotlighteds,
            recentRecommendeds: recentRecommendeds,
            recentRecommendedTitle: recentRecommendedTitle
        )
    }
}
