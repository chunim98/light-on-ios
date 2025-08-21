//
//  DatePickerFormComponentVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/21/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class DatePickerFormComponentVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    /// 날짜 선택 모달
    private let modalVC = DatePickerModalVC()
    
    /// 날짜 선택 버튼 스택 뷰
    private let buttonsHStack = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .caption
        config.text = "~"
        let label = LOLabel(config: config)
        
        let sv = UIStackView()
        sv.alignment = .center
        sv.spacing = 12
        
        sv.addArrangedSubview(label)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.snp.makeConstraints { $0.centerX.equalToSuperview() }
        return sv
    }()
    
    /// 시작 날짜 선택 버튼
    /// - Note: 시작과 종료 버튼을 하나의 버튼처럼 취급하고 있음
    private let startButton = {
        let button = ScheduleFormButton()
        button.iconView.image = .calendar
        button._titleLabel.config.text = "00/00/00"
        button.setStyle(style: .idle)
        return button
    }()
    
    /// 종료 날짜 선택 버튼
    /// - Note: 시작과 종료 버튼을 하나의 버튼처럼 취급하고 있음
    private let endButton = {
        let button = ScheduleFormButton()
        button.iconView.image = .calendar
        button._titleLabel.config.text = "00/00/00"
        button.setStyle(style: .idle)
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(buttonsHStack)
        buttonsHStack.insertArrangedSubview(startButton, at: 0)
        buttonsHStack.addArrangedSubview(endButton)
        
        buttonsHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        /// 선택한 날짜 범위
        ///
        /// 초기값 없어서 초기값 제공중
        let dateRange = modalVC.newDateRangePublisher
            .prepend(.init(start: nil, end: nil))
        
        /// 시작 모달 상태
        let startModalState = modalVC.isPresentedPublisher
            .withLatestFrom(dateRange) { ($0, $1) }
        
        // 모달 표시 여부와 선택된 날짜에 따라 버튼 스타일 및 타이틀 갱신
        startModalState
            .sink { [weak self] in self?.updateStartButton(isPresented: $0.0, dateRange: $0.1) }
            .store(in: &cancellables)
        
        // 피커 모달 띄우기
        Publishers
            .Merge(startButton.tapPublisher, endButton.tapPublisher)
            .sink { [weak self] in self?.presentDatePickerModal() }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension DatePickerFormComponentVC {
    /// 모달 표시 여부와 선택된 날짜에 따라 버튼 스타일 및 타이틀 갱신
    private func updateStartButton(isPresented: Bool, dateRange: DateRange) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd"
        
        /// 모달 표시 여부 및 날짜 선택 상태에 따른 버튼 스타일 설정
        ///
        /// start만 확인하는 이유는 날짜가 선택되면 end도 항상 함께 선택되기 때문
        let style: ScheduleFormButtonStyle
        style = isPresented ? .editing : (dateRange.start == nil ? .idle : .filled)
        startButton.setStyle(style: style)
        endButton.setStyle(style: style)
        
        // 선택된 날짜가 있으면 버튼 타이틀에 반영
        dateRange.start.map { startButton._titleLabel.config.text = formatter.string(from: $0) }
        dateRange.end.map { endButton._titleLabel.config.text = formatter.string(from: $0) }
    }
    
    /// 날짜 피커 모달 띄우기
    ///
    /// 모달 높이를 사전에 계산된 값으로 사용중
    private func presentDatePickerModal() {
        modalVC.sheetPresentationController?.detents = [.custom { _ in 464.6 }]
        present(modalVC, animated: true)
    }
    
    /// 시작일 퍼블리셔
    var startDatePublisher: AnyPublisher<String?, Never> {
        modalVC.newDateRangePublisher.map { range in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return range.start.map { formatter.string(from: $0) }
        }
        .eraseToAnyPublisher()
    }
    
    /// 종료일 퍼블리셔
    var endDatePublisher: AnyPublisher<String?, Never> {
        modalVC.newDateRangePublisher.map { range in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return range.end.map { formatter.string(from: $0) }
        }
        .eraseToAnyPublisher()
    }
}

