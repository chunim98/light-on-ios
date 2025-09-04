//
//  FetchIsArtistUC.swift
//  LightOn
//
//  Created by 신정욱 on 9/4/25.
//

import Combine

final class FetchIsArtistUC {
    
    private let repo: IsArtistRepo
    
    init(repo: IsArtistRepo) {
        self.repo = repo
    }
    
    /// 사용자 아티스트 상태 여부 조회
    /// - 로그인 상태일 때만  요청
    func execute(
        loginState: AnyPublisher<SessionManager.LoginState, Never>
    ) -> AnyPublisher<Bool, Never> {
        loginState
            .removeDuplicates()
            .compactMap { [weak self] in
                $0 == .login
                ? self?.repo.fetchIsArtist()
                : Empty<Bool, Never>().eraseToAnyPublisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}
