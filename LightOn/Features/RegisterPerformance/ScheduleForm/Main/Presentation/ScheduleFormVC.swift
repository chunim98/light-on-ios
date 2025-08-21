//
//  ScheduleFormVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/21/25.
//

import UIKit
import Combine

import SnapKit

final class ScheduleFormVC: UIViewController {
    
    // MARK: Components
    
    private let baseForm = {
        let form = BaseForm()
        form.titleLabel.config.text = "공연 일시"
        return form
    }()
    
    private let datePickerFormCompVC = DatePickerFormComponentVC()
    private let timePickerFormCompVC = TimePickerFormComponentVC()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addChild(datePickerFormCompVC)
        addChild(timePickerFormCompVC)
        
        view.addSubview(baseForm)
        baseForm.addArrangedSubview(datePickerFormCompVC.view)
        baseForm.addArrangedSubview(timePickerFormCompVC.view)
        
        baseForm.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        datePickerFormCompVC.didMove(toParent: self)
        timePickerFormCompVC.didMove(toParent: self)
    }
}

// MARK: Binders & Publishers

extension ScheduleFormVC {
    /// 현재 선택된 날짜 범위 업데이트
    func updateDateRange(_ dateRange: DateRange) {
        datePickerFormCompVC.updateDateRange(dateRange)
    }
    
    /// 시작일 퍼블리셔
    var startDatePublisher: AnyPublisher<String?, Never> {
        datePickerFormCompVC.dateRangePublisher.map { range in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return range.start.map { formatter.string(from: $0) }
        }
        .eraseToAnyPublisher()
    }
    
    /// 종료일 퍼블리셔
    var endDatePublisher: AnyPublisher<String?, Never> {
        datePickerFormCompVC.dateRangePublisher.map { range in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return range.end.map { formatter.string(from: $0) }
        }
        .eraseToAnyPublisher()
    }
    
    /// 시작 시간 퍼블리셔
    var startTimePublisher: AnyPublisher<String?, Never> {
        timePickerFormCompVC.startModalVC.timePublisher
    }
    
    /// 종료 시간 퍼블리셔
    var endTimePublisher: AnyPublisher<String?, Never> {
        timePickerFormCompVC.endModalVC.timePublisher
    }
}
