//
//  PopularListVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import Foundation
import Combine

final class PopularListVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let refreshEvent: AnyPublisher<Void, Never>
        let genreFilter: AnyPublisher<String, Never>
    }
    struct Output {
        /// 인기 공연 배열들
        let populars: AnyPublisher<[HashtagPerformanceCellItem], Never>
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
        let populars = getPerformancesUC.getPopulars(
            trigger: input.refreshEvent
        )
        
        /// 필터링된 인기공연 배열들
        let filteredPopulars = Publishers
            .CombineLatest(populars, input.genreFilter)
            .map { populars, genreFilter in
                guard genreFilter != "전체" else { return populars }
                return populars.filter { $0.hashtag == genreFilter }
            }
            .eraseToAnyPublisher()
        
        return Output(populars: filteredPopulars)
    }
}
