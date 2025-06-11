//
//  LODatePickerStyledBodyView.swift
//  LightOn
//
//  Created by 신정욱 on 5/14/25.
//

import UIKit
import Combine

import FSCalendar

final class LODatePickerStyledBodyView: LODatePickerBodyView {
    
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
        dataSource = self
        
        register(LODatePickerCell.self, forCellReuseIdentifier: LODatePickerCell.id)
        allowsMultipleSelection = true
        placeholderType = .none // 전후달의 날짜 비활성화
        today = nil // 오늘 날짜 비활성화
        
        appearance.weekdayFont = .pretendard.regular(18)
        appearance.weekdayTextColor = .assistive
        appearance.selectionColor = .clear // 자체 셀 선택 효과 비활성화(커스텀 셀 사용)
        calendarHeaderView.isHidden = true // 헤더 숨기기(커스텀 헤더 사용)
        headerHeight = .zero               // 헤더 숨기기(커스텀 헤더 사용)
    }
}

// MARK: - FSCalendarDataSource

extension LODatePickerStyledBodyView: FSCalendarDataSource {
    
    /// 커스텀 셀을 구성하기 위한 메서드
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
        
        // 셀 스타일 구성
        let selection: LODatePickerCell.SelectionType = {
            switch selectedDates.count {
            // 2개 선택된 경우
            case 2:
                let start = selectedDates[0]
                let end = selectedDates[1]
                
                if date == start {
                    return .start
                } else if date == end {
                    return .end
                } else if date > start && date < end {
                    return .inRange
                } else {
                    return .default
                }

            // 1개 선택된 경우
            case 1:
                let single = selectedDates[0]
                return date == single ? .single : .default

            default:
                return .default
            }
        }()
        
        // 구성한 스타일을 바탕으로 셀 구성
        cell.configure(selection: selection, date: date)
        return cell
    }
}

// MARK: - Preview

#Preview { LODatePickerStyledBodyView() }
