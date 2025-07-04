//
//  LoginVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

import Foundation
import Combine

final class LoginVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let email: AnyPublisher<String, Never>
        let pw: AnyPublisher<String, Never>
        let loginTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 로그인 완료 이벤트
        let loginComplete: AnyPublisher<Void, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let updateLoginStateUC = UpdateLoginStateUC()
    private let requestLoginUC: RequestLoginUC
    
    init(loginRepo: LoginRepo) {
        self.requestLoginUC = RequestLoginUC(repo: loginRepo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let loginStateSubject = CurrentValueSubject<LoginState, Never>(.init(email: "", pw: ""))
        
        updateLoginStateUC.execute(
            email: input.email,
            pw: input.pw,
            loginState: loginStateSubject.eraseToAnyPublisher()
        )
        .sink { loginStateSubject.send($0) }
        .store(in: &cancellables)
        
        let userToken = requestLoginUC.execute(
            trigger: input.loginTap,
            loginState: loginStateSubject.eraseToAnyPublisher()
        )
        
        // 로그인 성공 시, 발급받은 토큰 저장, 로그인 상태 업데이트
        userToken.sink {
            TokenKeychain.shared.save(.access, token: $0.accessToken)
            TokenKeychain.shared.save(.refresh, token: $0.refreshToken)
            SessionManager.shared.updateLoginState()
        }
        .store(in: &cancellables)
        
        let loginComplete = userToken.map { _ in }
            .eraseToAnyPublisher()
        
        return Output(loginComplete: loginComplete)
    }
}
