//
//  RequestPresignUpUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/3/25.
//

import Combine

final class RequestPresignUpUC {
    
    private let repo: PresignUpRepo
    
    init(repo: PresignUpRepo) {
        self.repo = repo
    }
    
    /// 임시 회원가입 요청 (임시 회원 번호 발급)
    func execute(
        trigger: AnyPublisher<Void, Never>,
        state: AnyPublisher<SignUpFirstStepState, Never>
    ) -> AnyPublisher<Int, Never> {
        trigger
            .withLatestFrom(state) { _, state in state }
            .compactMap { [weak self] in
                guard let email = $0.email, let pw = $0.password
                else { return AnyPublisher<Int, Never>?.none }
                
                return self?.repo.postEmailPW(email: email, pw: pw)
            }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
