//
//  RegisterBuskingUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import Combine

final class RegisterBuskingUC {
    
    private let repo: RegisterBuskingRepo
    
    init(repo: RegisterBuskingRepo) {
        self.repo = repo
    }
    
    /// 버스킹 등록 요청
    func execute(
        trigger: AnyPublisher<Void, Never>,
        info: AnyPublisher<RegisterBuskingInfo, Never>
    ) -> AnyPublisher<Void, Never> {
        trigger
            .withLatestFrom(info) { _, info in info }
            .compactMap { [weak self] in self?.repo.requestRegisterBusking(info: $0) }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
