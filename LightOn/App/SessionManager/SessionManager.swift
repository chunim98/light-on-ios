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
    
    /// 현재 로그인 상태 @Published
    @Published private(set) var loginState: LoginState = .unknown
    
    // MARK: UseCases
    
    private let clearTokenOnReinstallUC = ClearTokenOnReinstallUC()
    
    // MARK: Methods
    
    /// 로그인 상태 업데이트 (리프레시 토큰 유효기간 기반)
    func updateLoginState() {
        let credential = TokenCredential()
        
        if credential.requiresRefresh {
            print("[SessionManager] 로그인 만료")
            loginState = .logout
            
        } else {
            print("[SessionManager] 로그인 유효")
            loginState = .login
        }
        
#if DEBUG
        guard let accessExpireAt = credential.accessExpireAt,
              let refreshExpireAt = credential.refreshExpireAt
        else { return }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        print("""
        [엑세스 만료] \(formatter.string(from: accessExpireAt))
        [리프레시 만료] \(formatter.string(from: refreshExpireAt))
        
        
        """)
#endif
    }
    
    /// 재설치의 경우 잔여토큰 초기화
    func clearTokenOnReinstall() { clearTokenOnReinstallUC.execute() }
}
