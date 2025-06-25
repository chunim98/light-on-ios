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
    
    private let currentPageRepo: CurrentPageRepo
    private let formatDateHeaderUC: FormatDateHeaderUC
    private let changeMonthUC: ChangeMonthUC
    
    // MARK: Initializer
    
    init() {
        self.currentPageRepo = .init()
        self.formatDateHeaderUC = .init(repo: currentPageRepo)
        self.changeMonthUC = .init(repo: currentPageRepo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        
        // Preprocessing
        
        currentPageRepo.update(from: input.currentPage)
        
        // Publishers
        
        let currentPage = changeMonthUC.publisher(
            previous: input.previousButtonTapEvent,
            next: input.nextButtonTapEvent
        )
        
        let dateHeaderText = formatDateHeaderUC.publisher()
        
        return Output(
            currentPage: currentPage,
            dateHeaderText: dateHeaderText,
            dateRange: input.dateRange
        )
    }
}
