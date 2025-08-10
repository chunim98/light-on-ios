//
//  GetMyInfoUC.swift
//  LightOn
//
//  Created by 신정욱 on 8/10/25.
//

import Combine

final class GetMyInfoUC {
    
    private let repo: MyInfoRepo
    
    init(repo: MyInfoRepo) {
        self.repo = repo
    }
    
    /// 내 정보 조회
    func execute(
        trigger: AnyPublisher<Void, Never>
    ) -> AnyPublisher<MyInfo, Never> {
        trigger
            .compactMap { [weak self] in self?.repo.getMyInfo() }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
