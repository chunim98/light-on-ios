//
//  DeleteConcertUC.swift
//  LightOn
//
//  Created by 신정욱 on 9/7/25.
//

import Combine

final class DeleteConcertUC {
    
    private let repo: ModifyConcertRepo
    
    init(repo: ModifyConcertRepo) {
        self.repo = repo
    }
    
    /// 콘서트 취소 요청
    func execute(
        trigger: AnyPublisher<Void, Never>,
        id: Int
    ) -> AnyPublisher<Void, Never> {
        trigger
            .compactMap { [weak self] in self?.repo.requestDeleteConcert(id: id) }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
