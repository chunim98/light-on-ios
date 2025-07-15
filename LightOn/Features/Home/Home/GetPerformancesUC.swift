//
//  GetPerformancesUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import Combine

final class GetPerformancesUC {
    
    private let repo: PerformanceRepo
    
    init(repo: PerformanceRepo) {
        self.repo = repo
    }
    
    /// 인기공연 조회
    func getPopulars(
        trigger: AnyPublisher<Void, Never>
    ) -> AnyPublisher<[PopularCellItem], Never> {
        trigger
            .compactMap { [weak self] in self?.repo.requestPopular() }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
    
    /// 추천공연 조회
    func getRecommendeds(
        trigger: AnyPublisher<Void, Never>
    ) -> AnyPublisher<[RecommendCellItem], Never> {
        trigger
            .compactMap { [weak self] in self?.repo.requestRecommended() }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
