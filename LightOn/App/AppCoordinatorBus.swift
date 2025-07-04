//
//  AppCoordinatorBus.swift
//  LightOn
//
//  Created by 신정욱 on 6/28/25.
//

import Combine

final class AppCoordinatorBus {
    
    // MARK: Enum
    
    enum NavigationEvent { case login, signUp }
    
    // MARK: Singleton
    
    static let shared = AppCoordinatorBus()
    private init() {}
    
    /// 네비게이션 요청을 앱 코디네이터로 전송
    let navigationEventSubject = PassthroughSubject<NavigationEvent, Never>()
}
