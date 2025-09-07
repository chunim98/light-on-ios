//
//  AppCoordinatorBus.swift
//  LightOn
//
//  Created by 신정욱 on 6/28/25.
//

import Combine

final class AppCoordinatorBus {
    
    // MARK: Enum
    
    enum NavigationEvent {
        /// 로그인 화면
        case login
        /// 회원 가입 화면
        case signUp
        /// 공연 상세 정보 화면
        case performanceDetail(id: Int)
        /// 버스킹 등록 화면
        case registerBusking
        /// 일반 공연 등록 화면
        case registerConcert
        /// 버스킹 수정 화면
        case modifyBusking(id: Int)
        /// 콘서트 수정화면
        case modifyConcert(id: Int)
    }
    
    // MARK: Singleton
    
    static let shared = AppCoordinatorBus()
    private init() {}
    
    /// 네비게이션 요청을 앱 코디네이터로 전송
    let navigationEventSubject = PassthroughSubject<NavigationEvent, Never>()
    
    /// 네비게이션 요청을 앱 코디네이터로 전송
    func navigate(to destination: NavigationEvent) {
        navigationEventSubject.send(destination)
    }
}
