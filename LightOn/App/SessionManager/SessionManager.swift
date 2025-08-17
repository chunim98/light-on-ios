//
//  SessionManager.swift
//  LightOn
//
//  Created by 신정욱 on 6/28/25.
//

import Foundation
import Combine

final class SessionManager {
    
    // MARK: Enum
    
    enum LoginState: String { case unknown, login, logout }
    
    // MARK: Singleton
    
    static let shared = SessionManager()
    private init() {}
    
    // MARK: Outputs
    
    /// 현재 로그인 상태 서브젝트
    private let loginStateSubject = CurrentValueSubject<LoginState, Never>(.unknown)
    /// 현재 로그인 상태 스냅샷
    var loginState: LoginState { loginStateSubject.value }
    
    // MARK: UseCases
    
    private let clearTokenOnReinstallUC = ClearTokenOnReinstallUC()
    
    // MARK: Methods
    
    /// 로그인 상태 업데이트 (리프레시 토큰 유효기간 기반)
    func updateLoginState() {
        let credential = TokenCredential()
        
        if credential.requiresRefresh {
            print("[SessionManager] 로그인 만료")
            loginStateSubject.send(.logout)
            
        } else {
            print("[SessionManager] 로그인 유효")
            loginStateSubject.send(.login)
        }
        
#if DEBUG
        guard let accessExpireAt = credential.accessExpireAt,
              let refreshExpireAt = credential.refreshExpireAt
        else { return }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        print("""
        [SessionManager] accessExpireAt \(formatter.string(from: accessExpireAt))
        [SessionManager] refreshExpireAt \(formatter.string(from: refreshExpireAt))
        
        
        """)
#endif
    }
    
    /// 재설치의 경우 잔여토큰 초기화
    func clearTokenOnReinstall() { clearTokenOnReinstallUC.execute() }
}

// MARK: Binders & Publishers

extension SessionManager {
    /// 현재 로그인 상태 퍼블리셔
    /// - Important: 항상 메인 스레드로 방출되니 메인 스레드 블락하지 않게 조심!
    var loginStatePublisher: AnyPublisher<LoginState, Never> {
        loginStateSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
}
