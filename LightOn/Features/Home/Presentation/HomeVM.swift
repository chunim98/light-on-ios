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
    }
    struct Output {
        /// 인기 공연 배열들
        let populars: AnyPublisher<[PopularCellItem], Never>
        /// 추천 공연 배열들
        let recommendeds: AnyPublisher<[RecommendCellItem], Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let getPerformancesUC: GetPerformancesUC
    
    // MARK: Initializer
    
    init(repo: any PerformanceRepo) {
        self.getPerformancesUC = GetPerformancesUC(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let populars = getPerformancesUC.getPopulars(
            trigger: input.refreshEvent
        )
        
        let recommendeds = getPerformancesUC.getRecommendeds(
            trigger: input.refreshEvent
        )
        
        return Output(populars: populars, recommendeds: recommendeds)
    }
}
