//
//  LogoutAlertVM.swift
//  LightOn
//
//  Created by 신정욱 on 8/19/25.
//

import Foundation
import Combine

final class LogoutAlertVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        /// 로그아웃 요청 트리거
        let trigger: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 로그아웃 완료 이벤트
        let logoutCompleted: AnyPublisher<Void, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let logoutUC: LogoutUC
    
    init(repo: LogoutRepo) {
        self.logoutUC = .init(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 로그아웃 완료 이벤트
        let logoutCompleted = logoutUC.requestLogout(trigger: input.trigger)
        
        return Output(logoutCompleted: logoutCompleted)
    }
}
