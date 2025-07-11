//
//  ProvinceDropdownVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/11/25.
//

import Foundation
import Combine

final class ProvinceDropdownVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let buttonTap: AnyPublisher<Void, Never>
        let dismissTableEvent: AnyPublisher<Void, Never>
        let selectedProvince: AnyPublisher<Province, Never>
    }
    struct Output {
        /// 드롭다운 뷰 상태
        let state: AnyPublisher<ProvinceDropdownState, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let stateSubject = CurrentValueSubject<ProvinceDropdownState, Never>(.init(
            tableHidden: true, selectedProvince: nil
        ))
        
        let state = stateSubject.eraseToAnyPublisher()
        
        // 드롭다운 뷰 상태 업데이트
        Publishers.Merge3(
            input.buttonTap.withLatestFrom(state) {
                $1.updated(tableHidden: false)
            },
            input.dismissTableEvent.withLatestFrom(state) {
                $1.updated(tableHidden: true)
            },
            input.selectedProvince.withLatestFrom(state) {
                $1.updated(tableHidden: true, selectedProvince: .some($0))
            }
        )
        .sink { stateSubject.send($0) }
        .store(in: &cancellables)
        
        return Output(state: state)
    }
}
