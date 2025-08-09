//
//  GetMyRequestedUC.swift
//  LightOn
//
//  Created by 신정욱 on 8/9/25.
//

import Combine

final class GetMyRequestedUC {
    
    private let repo: MyRequestedRepo
    
    init(repo: MyRequestedRepo) {
        self.repo = repo
    }
    
    /// 내 공연 신청 or 등록 내역 조회
    func execute(
        trigger: AnyPublisher<Void, Never>
    ) -> AnyPublisher<[MyPerformanceCellItem], Never> {
        trigger
            .compactMap { [weak self] in self?.repo.getMyRequested() }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
