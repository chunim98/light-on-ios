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
        /// 데이터 로드 트리거
        let trigger: AnyPublisher<Void, Never>
        /// 장르 필터
        let genreFilter: AnyPublisher<String, Never>
    }
    struct Output {
        /// 인기 공연 배열
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
        /// 인기 공연 배열
        let performances = getPerformancesUC.getPopulars(trigger: input.trigger)
        
        /// 필터링된 인기공연 배열들
        let filteredPerformances = Publishers
            .CombineLatest(performances, input.genreFilter)
            .map { performances, genreFilter in
                guard genreFilter != "전체" else { return performances }
                return performances.filter { $0.hashtag == genreFilter }
            }
            .eraseToAnyPublisher()
        
        return Output(performances: filteredPerformances)
    }
}
