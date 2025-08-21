//
//  DatePickerModalVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/6/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class DatePickerModalVC: ModalVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let datePicker = LODatePicker()
    
    private let confirmButton = {
        let button = LOButton(style: .filled, height: 46)
        button.setTitle("확인", .pretendard.semiBold(16))
        button.isEnabled = false
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        titleLabel.config.foregroundColor = .brand
        titleLabel.config.text = "공연 시작일 선택"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.addArrangedSubview(LOSpacer(14))
        contentVStack.addArrangedSubview(datePicker)
        contentVStack.addArrangedSubview(LOSpacer(20))
        contentVStack.addArrangedSubview(confirmButton)
        contentVStack.addArrangedSubview(LOSpacer(10))
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        datePicker.dateRangePublisher
            .sink { [weak self] in self?.bindState($0) }
            .store(in: &cancellables)
        
        confirmButton.tapPublisher
            .sink { [weak self] in self?.dismiss(animated: true) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension DatePickerModalVC {
    /// 선택한 날짜 범위로 상태 갱신
    private func bindState(_ range: DateRange) {
        titleLabel.config.text = range.start == nil ? "공연 시작일 선택" : "공연 종료일 선택"
        confirmButton.isEnabled = range.start != nil
    }
    
    /// 현재 선택된 날짜 범위 업데이트
    func updateDateRange(_ dateRange: DateRange) {
        datePicker.updateDateRange(dateRange)
    }
    
    /// 선택된 날짜 범위를 방출하는 퍼블리셔
    ///
    /// - 시작일만 선택된 경우: 시작일과 같은 날짜를 종료일로 사용
    /// - 시작일과 종료일이 모두 선택된 경우: 해당 범위를 그대로 사용
    var dateRangePublisher: AnyPublisher<DateRange, Never> {
        confirmButton.tapPublisher
            .withLatestFrom(datePicker.dateRangePublisher)
            .map { DateRange(start: $0.start, end: $0.end ?? $0.start) }
            .eraseToAnyPublisher()
    }
    
    /// 모달 표시 여부 퍼블리셔
    var isPresentedPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            viewWillAppearPublisher.map { true },
            viewWillDisappearPublisher.map { false }
        )
        .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { DatePickerModalVC() }
