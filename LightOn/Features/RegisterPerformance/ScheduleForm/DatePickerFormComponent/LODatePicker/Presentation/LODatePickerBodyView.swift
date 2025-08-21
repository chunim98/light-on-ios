//
//  LODatePickerBodyView.swift
//  LightOn
//
//  Created by 신정욱 on 5/15/25.
//

import UIKit
import Combine

import FSCalendar

final class LODatePickerBodyView: FSCalendar {
    
    // MARK: Properties
    
    /// 오름차 정렬된 현재 선택된 날짜들
    override var selectedDates: [Date] { super.selectedDates.sorted() }
    
    // MARK: Subjects
    
    /// 현재 페이지(월 단위) 서브젝트
    ///
    /// 외부 방출 목적
    private lazy var currentPageSubject = CurrentValueSubject<Date, Never>(currentPage)
    
    /// 현재 선택된 날짜 범위 서브젝트
    ///
    /// 외부 방출 목적
    private let dateRangeSubject = PassthroughSubject<DateRange, Never>()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        register(LODatePickerCell.self, forCellReuseIdentifier: LODatePickerCell.id)
        allowsMultipleSelection = true
        placeholderType = .none // 전후달의 날짜 비활성화
        today = nil             // 오늘 날짜 비활성화
        
        appearance.weekdayFont = .pretendard.regular(18)
        appearance.weekdayTextColor = .assistive
        appearance.selectionColor = .clear  // 자체 셀 선택 효과 비활성화(커스텀 셀 사용)
        calendarHeaderView.isHidden = true  // 헤더 숨기기(커스텀 헤더 사용)
        headerHeight = .zero                // 헤더 숨기기(커스텀 헤더 사용)
        
        dataSource = self
        delegate = self
    }
}

// MARK: Binders & Publishers

extension LODatePickerBodyView {
    /// 다음 페이지(월 단위)로 이동
    func goToNextPage() {
        guard let nextPage = Calendar.current.date(
            byAdding: .month, value: 1, to: currentPage
        ) else { return }
        setCurrentPage(nextPage, animated: true)
    }
    
    /// 이전 페이지(월 단위)로 이동
    func goToPreviousPage() {
        guard let previousPage = Calendar.current.date(
            byAdding: .month, value: -1, to: currentPage
        ) else { return }
        setCurrentPage(previousPage, animated: true)
    }
    
    /// 현재 선택된 날짜 범위 업데이트
    ///
    /// 셀 상태 갱신을 위해 reloadData() 호출
    func updateDateRange(_ dateRange: DateRange) {
        selectedDates.forEach { deselect($0) }
        select(dateRange.start, scrollToDate: true)
        select(dateRange.end, scrollToDate: true)
        reloadData()
    }
    
    /// 현재 페이지(월 단위) 퍼블리셔
    var currentPagePublisher: AnyPublisher<Date, Never> {
        currentPageSubject.eraseToAnyPublisher()
    }
    
    /// 현재 선택된 날짜 범위 퍼블리셔
    var dateRangePublisher: AnyPublisher<DateRange, Never> {
        dateRangeSubject.eraseToAnyPublisher()
    }
}

// MARK: - FSCalendarDelegate

extension LODatePickerBodyView: FSCalendarDelegate {
    /// 달력 셀 선택 시 호출됨
    ///
    /// 현재 선택된 날짜 범위를 dateRangeSubject로 방출하고
    /// 셀 상태 갱신을 위해 reloadData() 호출
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        /// 현재 선택된 날짜 범위
        let dateRange = DateRange(
            start: selectedDates[safe: 0],
            end: selectedDates[safe: 1]
        )
        dateRangeSubject.send(dateRange)
        reloadData()
    }
    
    /// 달력 셀 선택 해제 시 호출됨
    ///
    /// 현재 선택된 날짜 범위를 dateRangeSubject로 방출하고
    /// 셀 상태 갱신을 위해 reloadData() 호출
    func calendar(
        _ calendar: FSCalendar,
        didDeselect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        /// 현재 선택된 날짜 범위
        let dateRange = DateRange(
            start: selectedDates[safe: 0],
            end: selectedDates[safe: 1]
        )
        dateRangeSubject.send(dateRange)
        reloadData()
    }
    
    /// 특정 날짜가 선택 가능한지 사전 판단할 때 호출됨
    ///
    /// 최대 2개까지만 선택 가능하도록 제한
    func calendar(
        _ calendar: FSCalendar,
        shouldSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) -> Bool {
        calendar.selectedDates.count < 2
    }
    
    /// 달력에서 현재 보고 있는 페이지(월 단위)가 바뀌면 호출됨
    func calendarCurrentPageDidChange(
        _ calendar: FSCalendar
    ) {
        currentPageSubject.send(currentPage)
    }
}

// MARK: - FSCalendarDataSource

extension LODatePickerBodyView: FSCalendarDataSource {
    /// 커스텀 셀 구성
    func calendar(
        _ calendar: FSCalendar,
        cellFor date: Date,
        at position: FSCalendarMonthPosition
    ) -> FSCalendarCell {
        
        // 셀 생성
        guard let cell = dequeueReusableCell(
            withIdentifier: LODatePickerCell.id,
            for: date,
            at: position
        ) as? LODatePickerCell else { return .init() }
        
        // 셀 선택 상태 생성
        let selection = LODatePickerCellSelection(
            selectedDates: selectedDates,
            date: date
        )
        
        // 생성한 상태를 바탕으로 셀 구성
        cell.configure(selection: selection, date: date)
        return cell
    }
}
