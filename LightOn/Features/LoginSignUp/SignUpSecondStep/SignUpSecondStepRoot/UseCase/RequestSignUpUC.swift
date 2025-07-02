//
//  RequestSignUpUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/3/25.
//

import Combine

final class RequestSignUpUC {
    
    private let repo: SignUpRepo
    
    init(repo: SignUpRepo) {
        self.repo = repo
    }
    
    /// 정식 회원가입 요청 (멤버 정보 전송)
    func execute(
        trigger: AnyPublisher<Void, Never>,
        memberInfo: AnyPublisher<MemberInfo, Never>
    ) -> AnyPublisher<UserToken, Never> {
        trigger
            .withLatestFrom(memberInfo) { _, info in info }
            .compactMap { [weak self] in self?.repo.postMemberInfo(memberInfo: $0) }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
