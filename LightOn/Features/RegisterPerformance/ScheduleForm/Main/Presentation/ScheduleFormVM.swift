//
//  ScheduleFormVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

import Foundation
import Combine

final class ScheduleFormVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let dateRange: AnyPublisher<(Date, Date)?, Never>
        let startTime: AnyPublisher<String?, Never>
        let endTime: AnyPublisher<String?, Never>
        let dateModalPresented: AnyPublisher<Bool, Never>
        let startTimeModalPresented: AnyPublisher<Bool, Never>
        let endTimeModalPresented: AnyPublisher<Bool, Never>
    }
    struct Output {
        /// 스케줄 폼 상태
        let state: AnyPublisher<ScheduleFormState, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let updateScheduleFormStateUC = UpdateScheduleFormStateUC()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let stateSubject = CurrentValueSubject<ScheduleFormState, Never>(.init(
            dateRange: nil, startTime: nil, endTime: nil,
            dateModalPresented: false,
            startTimeModalPresented: false,
            endTimeModalPresented: false,
            dateButtonsStyle: .idle,
            startTimeButtonStyle: .idle,
            endTimeButtonStyle: .idle,
            titleStyle: .idle
        ))
        
        updateScheduleFormStateUC.execute(
            dateRange: input.dateRange,
            startTime: input.startTime,
            endTime: input.endTime,
            dateModalPresented: input.dateModalPresented,
            startTimeModalPresented: input.startTimeModalPresented,
            endTimeModalPresented: input.endTimeModalPresented,
            state: stateSubject.eraseToAnyPublisher()
        )
        .sink { stateSubject.send($0) }
        .store(in: &cancellables)
        
        return Output(state: stateSubject.eraseToAnyPublisher())
    }
}
