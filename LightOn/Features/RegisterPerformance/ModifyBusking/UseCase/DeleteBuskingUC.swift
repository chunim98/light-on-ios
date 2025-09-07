//
//  DeleteBuskingUC.swift
//  LightOn
//
//  Created by 신정욱 on 8/29/25.
//

import Combine

final class DeleteBuskingUC {
    
    private let repo: DeleteBuskingRepo
    
    init(repo: DeleteBuskingRepo) {
        self.repo = repo
    }
    
    /// 버스킹 취소 요청
    func execute(
        trigger: AnyPublisher<Void, Never>,
        id: Int
    ) -> AnyPublisher<Void, Never> {
        trigger
            .compactMap { [weak self] in self?.repo.requestDeleteBusking(id: id) }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
