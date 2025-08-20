//
//  LODatePicker.swift
//  LightOn
//
//  Created by 신정욱 on 5/14/25.
//

import UIKit
import Combine

import SnapKit

final class LODatePicker: UIStackView {
    
    // MARK: Properties
    
    private let vm = LODatePickerVM()
    private var cancaellables = Set<AnyCancellable>()
    
    // MARK: Outputs
    
    private let dateRangeSubject = PassthroughSubject<DateRange, Never>()
    
    // MARK: Components
    
    private let pickerHeaderView = LODatePickerHeaderView()
    private let pickerBodyView = LODatePickerStyledBodyView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(horizontal: 18)
        axis = .vertical
        spacing = 20
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(pickerHeaderView)
        addArrangedSubview(pickerBodyView)
        self.snp.makeConstraints { $0.height.equalTo(318) }
    }
    
    // MARK: Bindig
    
    private func setupBindings() {
        let input = LODatePickerVM.Input(
            previousButtonTapEvent: pickerHeaderView.previousTapPublisher,
            nextButtonTapEvent: pickerHeaderView.nextTapPublisher,
            currentPage: pickerBodyView.currentPagePublisher,
            dateRange: pickerBodyView.dateRangePublisher
        )
        let output = vm.transform(input)
        
        output.currentPage
            .sink { [weak self] in self?.pickerBodyView.currentPageBinder($0) }
            .store(in: &cancaellables)
        
        output.dateHeaderText
            .sink { [weak self] in self?.pickerHeaderView.bindDateHeaderText($0) }
            .store(in: &cancaellables)
        
        output.dateRange
            .sink { [weak self] in self?.dateRangeSubject.send($0) }
            .store(in: &cancaellables)
    }
}

// MARK: Binders & Publishers

extension LODatePicker {
    /// 선택한 날짜 범위 퍼블리셔
    var dateRangePublisher: AnyPublisher<DateRange, Never> {
        dateRangeSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { LODatePicker() }
