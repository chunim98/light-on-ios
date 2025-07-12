//
//  CityDropdownVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/11/25.
//

import Foundation
import Combine

final class CityDropdownVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let buttonTap: AnyPublisher<Void, Never>
        let dismissTableEvent: AnyPublisher<Void, Never>
        let selectedProvince: AnyPublisher<Province?, Never>
        let selectedCity: AnyPublisher<City, Never>
    }
    struct Output {
        /// 드롭다운 뷰 상태
        let state: AnyPublisher<CityDropdownState, Never>
        /// 지역 단위 배열
        let cities: AnyPublisher<[City], Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let stateSubject = CurrentValueSubject<CityDropdownState, Never>(.init(
            tableHidden: true, selectedProvince: nil, selectedCity: nil
        ))
        
        let state = stateSubject.eraseToAnyPublisher()
        
        /// 지역 단위 배열
        let cities = state
            .compactMap { $0.selectedProvince }
            .compactMap { City.cities[$0] }
            .eraseToAnyPublisher()
        
        // 드롭다운 뷰 상태 업데이트
        Publishers.Merge4(
            input.buttonTap.withLatestFrom(state) {
                $1.updated(tableHidden: false)
            },
            input.dismissTableEvent.withLatestFrom(state) {
                $1.updated(tableHidden: true)
            },
            input.selectedProvince.withLatestFrom(state) {
                $1.updated(
                    tableHidden: true,
                    selectedProvince: .some($0),
                    selectedCity: .some(nil)
                )
            },
            input.selectedCity.withLatestFrom(state) {
                $1.updated(tableHidden: true, selectedCity: .some($0))
            }
        )
        .sink { stateSubject.send($0) }
        .store(in: &cancellables)
        
        return Output(state: state, cities: cities)
    }
}
