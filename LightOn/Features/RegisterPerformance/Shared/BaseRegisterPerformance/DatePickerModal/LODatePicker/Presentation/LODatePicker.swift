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
    
    private var cancaellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let pickerHeaderView = LODatePickerHeaderView()
    private let pickerBodyView = LODatePickerBodyView()
    
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
        // 헤더에서 이전 버튼을 누르면, 이전 달 페이지로 이동
        pickerHeaderView.previousTapPublisher
            .sink { [weak self] in self?.pickerBodyView.goToPreviousPage() }
            .store(in: &cancaellables)
        
        // 헤더에서 다음 버튼을 누르면, 다음 달 페이지로 이동
        pickerHeaderView.nextTapPublisher
            .sink { [weak self] in self?.pickerBodyView.goToNextPage() }
            .store(in: &cancaellables)
        
        // 현재 페이지가 바뀌면, 헤더 타이틀을 갱신
        pickerBodyView.currentPagePublisher
            .sink { [weak self] in self?.updateHeaderTitle(with: $0) }
            .store(in: &cancaellables)
    }
}

// MARK: Binders & Publishers

extension LODatePicker {
    /// 전달받은 날짜를 "yyyy년 M월" 형식으로 변환 후, 헤더 타이틀 갱신
    private func updateHeaderTitle(with date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        formatter.dateFormat = "yyyy년 M월"
        pickerHeaderView.setTitle(formatter.string(from: date))
    }
    
    /// 현재 선택된 날짜 범위 업데이트
    func updateDateRange(_ dateRange: DateRange) {
        pickerBodyView.updateDateRange(dateRange)
    }
    
    /// 선택한 날짜 범위 퍼블리셔
    var dateRangePublisher: AnyPublisher<DateRange, Never> {
        pickerBodyView.dateRangePublisher
    }
}

// MARK: - Preview

#Preview { LODatePicker() }
