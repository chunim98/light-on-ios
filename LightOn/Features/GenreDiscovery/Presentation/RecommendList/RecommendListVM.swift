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
        /// 데이터 로드 트리거
        let trigger: AnyPublisher<SessionManager.LoginState, Never>
    }
    struct Output {
        /// 최신 or 추천 공연 배열
        let performances: AnyPublisher<[HashtagPerformanceCellItem], Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let getPerformancesUC: GetHashtagPerformancesUC
    
    // MARK: Initializer
    
    init(repo: any GenreDiscoveryRepo) {
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
