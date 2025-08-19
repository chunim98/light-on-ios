//
//  DeleteAccountUC.swift
//  LightOn
//
//  Created by 신정욱 on 8/19/25.
//

import Combine

final class DeleteAccountUC {
    
    private let repo: DeleteAccountRepo
    
    init(repo: DeleteAccountRepo) {
        self.repo = repo
    }
    
    /// 서버에 회원 탈퇴 요청
    func execute(
        trigger: AnyPublisher<Void, Never>
    ) -> AnyPublisher<Void, Never> {
        trigger
            .compactMap { [weak self] in self?.repo.requestDeleteAccount() }
            .switchToLatest()
            .handleEvents(receiveOutput: {
                TokenKeychain.shared.delete(.access)
                TokenKeychain.shared.delete(.refresh)
                TokenKeychain.shared.delete(.fcm)
                SessionManager.shared.updateLoginState()
            })
            .share()
            .eraseToAnyPublisher()
    }
    
}
