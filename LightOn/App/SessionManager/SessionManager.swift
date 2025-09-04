//
//  SessionManager.swift
//  LightOn
//
//  Created by 신정욱 on 6/28/25.
//

import Foundation
import Combine

final class SessionManager {
    
    // MARK: LoginState
    
    enum LoginState: String { case unknown, login, logout }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let clearTokenOnReinstallUC = ClearTokenOnReinstallUC()
    private let fetchIsArtistUC = FetchIsArtistUC(repo: DefaultIsArtistRepo())
    
    // MARK: Subjects
    
    /// 현재 로그인 상태 서브젝트
    private let loginStateSubject = CurrentValueSubject<LoginState, Never>(.unknown)
    /// 사용자 아티스트 여부 서브젝트
    private let isArtistSubject = CurrentValueSubject<Bool, Never>(false)
    
    /// 현재 로그인 상태 스냅샷
    var loginState: LoginState { loginStateSubject.value }
    /// 사용자 아티스트 여부 스냅샷
    var isArtist: Bool { isArtistSubject.value }
    
    // MARK: Singleton
    
    static let shared = SessionManager()
    private init() { setupBindings() }
    
    // MARK: Bindings
    
    private func setupBindings() {
        fetchIsArtistUC
            .execute(loginState: loginStateSubject.eraseToAnyPublisher())
            .sink(receiveValue: isArtistSubject.send(_:))
            .store(in: &cancellables)
    }
    
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
    ///
    /// 항상 메인 스레드로 방출됨
    ///
    /// - Warning: 이 퍼블리셔를 API 호출 트리거로 직접 사용하면, 토큰 재발급 루프가 발생할 수 있음!
    ///   API 호출 트리거로 사용하고자 한다면, `prefix(1)` 같은 안전장치를 두어 루프 발생을 예방해야 함!
    var loginStatePublisher: AnyPublisher<LoginState, Never> {
        loginStateSubject
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
