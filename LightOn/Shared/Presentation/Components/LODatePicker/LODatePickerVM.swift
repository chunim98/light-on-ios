//
//  LODatePickerVM.swift
//  LightOn
//
//  Created by 신정욱 on 5/15/25.
//

import Foundation
import Combine

final class LODatePickerVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let previousButtonTapEvent: AnyPublisher<Void, Never>
        let nextButtonTapEvent: AnyPublisher<Void, Never>
        let currentPage: AnyPublisher<Date, Never>
        let dateRange: AnyPublisher<DateRange, Never>
    }
    
    struct Output {
        let currentPage: AnyPublisher<Date, Never>
        let dateHeaderText: AnyPublisher<String, Never>
        let dateRange: AnyPublisher<DateRange, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        
        // States
        
        let currentPageSubject = CurrentValueSubject<Date?, Never>(nil)
        
        // Preprocessing
        
        // 외부의 상태를 내부로 복사
        input.currentPage
            .sink { currentPageSubject.send($0) }
            .store(in: &cancellables)
        
        // 이전, 다음 달 계산을 위한 오프셋
        let monthOffset = Publishers.Merge(
            input.previousButtonTapEvent.map { _ in -1 },
            input.nextButtonTapEvent.map { _ in 1 }
        )
        
        // Output Publishers
        
        let currentPage = monthOffset
            .compactMap { offset -> Date? in
                guard let date = currentPageSubject.value else { return nil }
                return Calendar.current.date(byAdding: .month, value: offset, to: date)
            }
            .eraseToAnyPublisher()
        
        let dateHeaderText = input.currentPage
            .map {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
                formatter.dateFormat = "yyyy년 M월"
                return formatter.string(from: $0)
            }
            .eraseToAnyPublisher()
        
        return Output(
            currentPage: currentPage,
            dateHeaderText: dateHeaderText,
            dateRange: input.dateRange
        )
    }
}
