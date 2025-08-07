//
//  GetMyStatsInfoUC.swift
//  LightOn
//
//  Created by 신정욱 on 8/8/25.
//

import Combine

final class GetMyStatsInfoUC {
    
    private let repo: MyStatsInfoRepo
    
    init(repo: MyStatsInfoRepo) {
        self.repo = repo
    }
    
    /// 내 활동 통계 조회
    func execute(
        trigger: AnyPublisher<Void, Never>
    ) -> AnyPublisher<MyStatsInfo, Never> {
        trigger
            .compactMap { [weak self] in self?.repo.getMyStatsInfo() }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
