//
//  UpdateScheduleFormStateUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

import Foundation

import Combine

final class UpdateScheduleFormStateUC {
    /// 스케줄 폼 상태 갱신
    func execute(
        dateRange: AnyPublisher<(Date, Date)?, Never>,
        startTime: AnyPublisher<String?, Never>,
        endTime: AnyPublisher<String?, Never>,
        dateModalPresented: AnyPublisher<Bool, Never>,
        startTimeModalPresented: AnyPublisher<Bool, Never>,
        endTimeModalPresented: AnyPublisher<Bool, Never>,
        state: AnyPublisher<ScheduleFormState, Never>
    ) -> AnyPublisher<ScheduleFormState, Never> {
        let dateRangeUpdate = dateRange
            .withLatestFrom(state) { $1.updated(dateRange: .some($0)) }
        
        let startTimeUpdate = startTime
            .withLatestFrom(state) { $1.updated(startTime: .some($0)) }
        
        let endTimeUpdate = endTime
            .withLatestFrom(state) { $1.updated(endTime: .some($0)) }
        
        let dateModalUpdate = dateModalPresented
            .withLatestFrom(state) { $1.updated(dateModalPresented: $0) }
        
        let startTimeModalUpdate = startTimeModalPresented
            .withLatestFrom(state) { $1.updated(startTimeModalPresented: $0) }
        
        let endTimeModalUpdate = endTimeModalPresented
            .withLatestFrom(state) { $1.updated(endTimeModalPresented: $0) }
        
        return Publishers.Merge6(
            dateRangeUpdate,
            startTimeUpdate,
            endTimeUpdate,
            dateModalUpdate,
            startTimeModalUpdate,
            endTimeModalUpdate
        )
        .map {
            // 스타일 업데이트
            $0.updated(
                dateButtonsStyle: $0.dateModalPresented ?
                    .editing : $0.dateRange == nil ? .idle : .filled,
                
                startTimeButtonStyle: $0.startTimeModalPresented ?
                    .editing : $0.startTime == nil ? .idle : .filled,
                
                endTimeButtonStyle: $0.endTimeModalPresented ?
                    .editing : $0.endTime == nil ? .idle : .filled
            )
        }
        .eraseToAnyPublisher()
    }
}
