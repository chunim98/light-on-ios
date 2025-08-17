//
//  HomeRecentRecommendedVM.swift
//  LightOn
//
//  Created by 신정욱 on 8/17/25.
//

import Foundation
import Combine

final class HomeRecentRecommendedVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        /// 데이터 로드 트리거 (로그인 상태 + viewDidAppear)
        let trigger: AnyPublisher<SessionManager.LoginState, Never>
    }
    struct Output {
        /// 최신 or 추천 공연 배열
        let performances: AnyPublisher<[SmallPerformanceCellItem], Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let getPerformancesUC: GetPerformancesUC
    
    // MARK: Initializer
    
    init(repo: any PerformanceRepo) {
        self.getPerformancesUC = .init(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 최신 or 추천 공연 배열
        let performances = getPerformancesUC
            .getRecentRecommendeds(loginState: input.trigger)
        
        return Output(performances: performances)
    }
}
