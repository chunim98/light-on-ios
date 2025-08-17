//
//  HomePopularVM.swift
//  LightOn
//
//  Created by 신정욱 on 8/17/25.
//

import Foundation
import Combine

final class HomePopularVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        /// 데이터 로드 트리거
        let trigger: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 인기 공연 배열
        let performances: AnyPublisher<[LargePerformanceCellItem], Never>
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
        /// 인기 공연 배열
        let performances = getPerformancesUC.getPopulars(trigger: input.trigger)
        
        return Output(performances: performances)
    }
}
