//
//  SessionManager.swift
//  LightOn
//
//  Created by 신정욱 on 6/28/25.
//

import Foundation
import Combine

import Alamofire

final class SessionManager {
    
    // MARK: Enum
    
    enum LoginState: String { case unknown, login, logout }
    
    // MARK: Outputs
    
    /// 현재 로그인 상태 @Published
    @Published private(set) var loginState: LoginState = .unknown
    
    // MARK: Singleton
    
    static let shared = SessionManager()
    private init() {}
    
    // MARK: Private Helper
    
    /// 토큰 유효기간 체크
    private func checkTokenExpired(_ exp: Date?) -> Bool {
        guard let exp else { return false }
        let now = Date()
        // 토큰 유효기간이 10분 이상 남아있어야 유효
        return now < exp && exp.timeIntervalSince(now) >= 600
    }
    
    // MARK: Methods
    
    /// 토큰의 검사, 갱신, 결과 방출을 시작
    func updateLoginState() {
        let accessEXP = TokenKeychain.shared.getEXP(.access)
        let refreshEXP = TokenKeychain.shared.getEXP(.refresh)
        
        if checkTokenExpired(accessEXP) {
            // 로그인이 유효하다고 방출
            loginState = .login
            print("SessionManager: 액세스 토큰 유효")
            
        } else if checkTokenExpired(refreshEXP) {
            APIClient.shared.reissueToken { [weak self] in
                // 로그인이 유효하다고 방출
                self?.loginState = .login
                print("SessionManager: 액세스 토큰 재발급 성공")
                
            } errorHandler: { [weak self] in
                // 재로그인 요청 방출
                self?.loginState = .logout
                print("SessionManager: 액세스 토큰 재발급 실패")
            }
            
        } else {
            // 재로그인 요청 방출
            loginState = .logout
            print("SessionManager: 리프레시 토큰 만료")
        }
    }
}
