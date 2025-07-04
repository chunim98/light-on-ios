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
    
    struct Input {}
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
        
        return Output(state: stateSubject.eraseToAnyPublisher())
    }
}
