//
//  LODatePickerBodyView.swift
//  LightOn
//
//  Created by 신정욱 on 5/15/25.
//

import UIKit
import Combine

import FSCalendar

class LODatePickerBodyView: FSCalendar {

    // MARK: Properties

    override var selectedDates: [Date] { super.selectedDates.sorted() }
    private var dateRange: DateRange {
        DateRange(start: selectedDates[safe: 0], end: selectedDates[safe: 1])
    }
    private let maxSelection = 2 // 선택 가능 갯수
    
    // MARK: Output Subjects
    
    private lazy var currentPageSubject = CurrentValueSubject<Date, Never>(currentPage)
    private let dateRangeSubject = PassthroughSubject<DateRange, Never>()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: Publishers

extension LODatePickerBodyView {
    var currentPagePublisher: AnyPublisher<Date, Never> {
        currentPageSubject.eraseToAnyPublisher()
    }
    
    var dateRangePublisher: AnyPublisher<DateRange, Never> {
        dateRangeSubject.eraseToAnyPublisher()
    }
}

// MARK: - FSCalendarDelegate

extension LODatePickerBodyView: FSCalendarDelegate {
    // 셀이 선택되었을 때 호출됨
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        dateRangeSubject.send(dateRange)
        reloadData()
    }
    
    // 셀이 선택 해제되었을 때 호출됨
    func calendar(
        _ calendar: FSCalendar,
        didDeselect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        dateRangeSubject.send(dateRange)
        reloadData()
    }
    
    func calendar(
        _ calendar: FSCalendar,
        shouldSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) -> Bool {
        calendar.selectedDates.count < maxSelection // 최대 2개 날짜까지 선택 가능
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        currentPageSubject.send(currentPage)
    }
}
