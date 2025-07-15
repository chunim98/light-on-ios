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
    }
    struct Output {
        /// 인기 공연 배열들
        let recommendeds: AnyPublisher<[HashtagPerformanceCellItem], Never>
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
        let recommendeds = getPerformancesUC.getRecommendeds(
            trigger: input.refreshEvent
        )
        
        return Output(recommendeds: recommendeds)
    }
}
