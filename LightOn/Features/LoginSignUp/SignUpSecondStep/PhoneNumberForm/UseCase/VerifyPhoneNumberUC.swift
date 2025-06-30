//
//  VerifyPhoneNumberUC.swift
//  LightOn
//
//  Created by 신정욱 on 6/30/25.
//

import Combine

final class VerifyPhoneNumberUC {
    
    private let repo: AuthCodeRepo
    
    init(repo: AuthCodeRepo) {
        self.repo = repo
    }
    
    /// 휴대폰 번호 최종 인증 요청
    func execute(
        trigger: AnyPublisher<Void, Never>,
        state: AnyPublisher<PhoneNumberFormState, Never>
    ) -> AnyPublisher<Void, Never> {
        trigger
            .withLatestFrom(state) { _, state in state }
            .compactMap { [weak self] in self?.repo.postAuthCode(state: $0) }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
