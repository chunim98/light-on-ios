//
//  MyPageVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

import Foundation
import Combine

final class MyPageVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let loginTap: AnyPublisher<Void, Never>
        let signUpTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 뷰 상태
        let state: AnyPublisher<MyPageState, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let updateMyPageStateUC = UpdateMyPageStateUC()
    
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let stateSubject = CurrentValueSubject<MyPageState, Never>(.logout)

        updateMyPageStateUC.execute()
            .sink { stateSubject.send($0) }
            .store(in: &cancellables)
        
        input.loginTap
            .sink { AppCoordinatorBus.shared.navigationEventSubject.send(.login) }
            .store(in: &cancellables)
        
        input.signUpTap
            .sink { AppCoordinatorBus.shared.navigationEventSubject.send(.signUp) }
            .store(in: &cancellables)
        
        return Output(state: stateSubject.eraseToAnyPublisher())
    }
}
