//
//  GetHashtagPerformancesUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import Combine

final class GetHashtagPerformancesUC {
    
    private let repo: GenreDiscoveryRepo
    
    init(repo: GenreDiscoveryRepo) {
        self.repo = repo
    }
    
    /// 인기공연 조회
    func getPopulars(
        trigger: AnyPublisher<Void, Never>
    ) -> AnyPublisher<[HashtagPerformanceCellItem], Never> {
        trigger
            .compactMap { [weak self] in self?.repo.requestPopular() }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
    
    /// 추천공연 조회
    func getRecommendeds(
        trigger: AnyPublisher<Void, Never>
    ) -> AnyPublisher<[HashtagPerformanceCellItem], Never> {
        trigger
            .compactMap { [weak self] in self?.repo.requestRecommended() }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
