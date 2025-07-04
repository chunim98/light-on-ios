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
        email: AnyPublisher<EmailState, Never>,
        pw: AnyPublisher<PWState, Never>
    ) -> AnyPublisher<Int, Never> {
        let emailPW = Publishers.CombineLatest(email, pw)
            .map { ($0.0.text, $0.1.text) }
        
        return trigger
            .withLatestFrom(emailPW) { ($1.0, $1.1) }
            .compactMap { [weak self] in self?.repo.postEmailPW(email: $0.0, pw: $0.1) }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
