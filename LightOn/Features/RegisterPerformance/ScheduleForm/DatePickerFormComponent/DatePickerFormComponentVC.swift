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
    
    // MARK: State
    
    struct State {
        /// 선택한 날짜 범위
        var dateRange: DateRange = DateRange(start: Date?.none, end: Date?.none)
        /// 날짜 선택 모달 표시 여부
        var isPresenting: Bool = false
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Subjects
    
    /// 현재 선택된 날짜 범위 업데이트 서브젝트
    ///
    /// 입력 목적
    private let updateDateRangeSubject = PassthroughSubject<DateRange, Never>()
    
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
        /// 모달과 버튼의 상태를 한곳에서 관리하기 위한 SOT 서브젝트
        let stateSubject = CurrentValueSubject<State, Never>(.init())
        
        // 모달 표시여부 갱신
        modalVC.isPresentedPublisher
            .sink { stateSubject.value.isPresenting = $0 }
            .store(in: &cancellables)
        
        // 모달에서 선택된 값과 외부에서 요청된 날짜 범위 변경 이벤트를 병합해 상태 반영
        Publishers
            .Merge(
                updateDateRangeSubject.eraseToAnyPublisher(),
                modalVC.dateRangePublisher
            )
            .sink { stateSubject.value.dateRange = $0 }
            .store(in: &cancellables)
        
        // 상태 변화에 따라 모달의 날짜 범위와 버튼 UI를 동기화
        stateSubject
            .sink { [weak self] in
                self?.modalVC.updateDateRange($0.dateRange)
                self?.updateButton(with: $0)
            }
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
    private func updateButton(with state: State) {
        let isPresenting = state.isPresenting
        let dateRange = state.dateRange
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd"
        
        /// 모달 표시 여부 및 날짜 선택 상태에 따른 버튼 스타일 설정
        ///
        /// start만 확인하는 이유는 날짜가 선택되면 end도 항상 함께 선택되기 때문
        let style: ScheduleFormButtonStyle
        style = isPresenting ? .editing : (dateRange.start == nil ? .idle : .filled)
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
    
    /// 선택된 날짜 범위 갱신
    ///
    /// 직접 상태를 수정하지 않고, Subject를 통해 변경 요청을 전달함
    func updateDateRange(_ dateRange: DateRange) {
        updateDateRangeSubject.send(dateRange)
    }
    
    /// 선택된 날짜 범위를 방출하는 퍼블리셔
    var dateRangePublisher: AnyPublisher<DateRange, Never> {
        modalVC.dateRangePublisher
    }
}

