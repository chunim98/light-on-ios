//
//  RequestAuthCodeSMSUC.swift
//  LightOn
//
//  Created by 신정욱 on 6/29/25.
//

import Combine

final class RequestAuthCodeSMSUC {
    
    private let repo: AuthCodeRepo
    
    init(repo: AuthCodeRepo) {
        self.repo = repo
    }
    
    /// 인증코드 문자 발송 요청
    func execute(
        trigger1: AnyPublisher<Void, Never>,
        trigger2: AnyPublisher<Void, Never>,
        state: AnyPublisher<PhoneNumberFormState, Never>
    ) -> AnyPublisher<Void, Never> {
        Publishers.Merge(trigger1, trigger2)
            .withLatestFrom(state) { _, state in state }
            .compactMap { [weak self] in self?.repo.requestAuthCodeSMS(state: $0) }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
