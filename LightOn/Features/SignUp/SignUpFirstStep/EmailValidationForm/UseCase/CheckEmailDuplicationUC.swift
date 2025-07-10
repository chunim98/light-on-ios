//
//  CheckEmailDuplicationUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

import Combine

final class CheckEmailDuplicationUC {
    private let repo: CheckEmailDuplicationRepo
    
    init(repo: CheckEmailDuplicationRepo) {
        self.repo = repo
    }
    
    /// 이메일 중복 확인 요청
    func execute(
        trigger: AnyPublisher<Void, Never>,
        state: AnyPublisher<EmailValidationFormState, Never>
    ) -> AnyPublisher<EmailValidationFormState.Duplication, Never> {
        trigger
            .withLatestFrom(state) { _, state in state.email }
            .compactMap { [weak self] in self?.repo.checkEmailDuplication(email: $0) }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
