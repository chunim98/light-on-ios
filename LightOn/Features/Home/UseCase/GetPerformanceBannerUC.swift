//
//  GetPerformanceBannerUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/23/25.
//

import Combine

final class GetPerformanceBannerUC {
    
    private let repo: PerformanceBannerRepo
    
    init(repo: PerformanceBannerRepo) {
        self.repo = repo
    }
    
    /// 배너 공연 조회
    func execute() -> AnyPublisher<[PerformanceBannerItem], Never> {
        repo.requestBanner().share().eraseToAnyPublisher()
    }
}
