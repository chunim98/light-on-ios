//
//  ScheduleForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/6/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class ScheduleForm: BaseForm {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = ScheduleFormVM()
    
    private weak var presenter: UIViewController?
    
    // MARK: Outputs
    
    /// 선택한 날짜, 시간을 외부 방출하는 서브젝트
    private let stateSubject = PassthroughSubject<ScheduleFormState, Never>()
    
    // MARK: Modals
    
    private let datePickerModalVC = DatePickerModalVC()                     // 컴포넌트 취급
    private let startTimePickerModalVC = TimePickerModalVC(config: .start)  // 컴포넌트 취급
    private let endTimePickerModalVC = TimePickerModalVC(config: .end)      // 컴포넌트 취급
    
    // MARK: Containers
    
    private let dateHStack = {
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
    
    private let timeHStack = {
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
    
    // MARK: Buttons
    
    private let startDateButton = {
        let button = ScheduleFormButton()
        button.iconView.image = .calendar
        button._titleLabel.config.text = "00/00/00"
        button.setStyle(style: .idle)
        return button
    }()
    
    private let endDateButton = {
        let button = ScheduleFormButton()
        button.iconView.image = .calendar
        button._titleLabel.config.text = "00/00/00"
        button.setStyle(style: .idle)
        return button
    }()
    
    private let startTimeButton = {
        let button = ScheduleFormButton()
        button.iconView.image = .timer
        button._titleLabel.config.text = "00:00"
        button.setStyle(style: .idle)
        return button
    }()
    
    private let endTimeButton = {
        let button = ScheduleFormButton()
        button.iconView.image = .timer
        button._titleLabel.config.text = "00:00"
        button.setStyle(style: .idle)
        return button
    }()
    
    // MARK: Life Cycle
    
    init(presenter: UIViewController?) {
        self.presenter = presenter
        super.init(frame: .zero)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        titleLabel.config.text = "공연 일시"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(dateHStack)
        addArrangedSubview(timeHStack)
        
        dateHStack.insertArrangedSubview(startDateButton, at: 0)
        dateHStack.addArrangedSubview(endDateButton)
        
        timeHStack.insertArrangedSubview(startTimeButton, at: 0)
        timeHStack.addArrangedSubview(endTimeButton)
        
        self.snp.makeConstraints { $0.width.equalTo(350) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = ScheduleFormVM.Input(
            dateRange: datePickerModalVC.dateRangePublisher,
            startTime: startTimePickerModalVC.timePublisher,
            endTime: endTimePickerModalVC.timePublisher,
            dateModalPresented: datePickerModalVC.isPresentedPublisher,
            startTimeModalPresented: startTimePickerModalVC.isPresentedPublisher,
            endTimeModalPresented: endTimePickerModalVC.isPresentedPublisher
        )
        
        let output = vm.transform(input)
        
        output.state
            .sink { [weak self] in
                self?.stateSubject.send($0)
                self?.bindState(state: $0)
            }
            .store(in: &cancellables)
        
        Publishers
            .Merge(startDateButton.tapPublisher, endDateButton.tapPublisher)
            .sink { [weak self] in self?.bindShowDatePickerModal() }
            .store(in: &cancellables)
        
        startTimeButton.tapPublisher
            .sink { [weak self] in self?.bindShowStartTimePickerModalVC() }
            .store(in: &cancellables)
        
        endTimeButton.tapPublisher
            .sink { [weak self] in self?.bindShowEndTimePickerModalVC() }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension ScheduleForm {
    /// 폼 상태 바인딩
    private func bindState(state: ScheduleFormState) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd"
        
        if let range = state.dateRange {
            startDateButton._titleLabel.config.text = formatter.string(from: range.0)
            endDateButton._titleLabel.config.text = formatter.string(from: range.1)
        }
        
        if let startTime = state.startTime {
            startTimeButton._titleLabel.config.text = startTime
        }
        
        if let endTime = state.endTime {
            endTimeButton._titleLabel.config.text = endTime
        }
        
        startDateButton.setStyle(style: state.dateButtonsStyle)
        endDateButton.setStyle(style: state.dateButtonsStyle)
        startTimeButton.setStyle(style: state.startTimeButtonStyle)
        endTimeButton.setStyle(style: state.endTimeButtonStyle)
    }
    
    /// 날짜 피커 모달 표시
    private func bindShowDatePickerModal() {
        let vc = datePickerModalVC
        vc.sheetPresentationController?.detents = [.custom { _ in 464.6 }]  // 사전 계산한 모달 높이
        presenter?.present(vc, animated: true)
    }
    
    /// 시작 시간 피커 모달 표시
    private func bindShowStartTimePickerModalVC() {
        let vc = startTimePickerModalVC
        vc.sheetPresentationController?.detents = [.custom { _ in 256.6 }]  // 사전 계산한 모달 높이
        presenter?.present(vc, animated: true)
    }
    
    /// 종료 시간 피커 모달 표시
    private func bindShowEndTimePickerModalVC() {
        let vc = endTimePickerModalVC
        vc.sheetPresentationController?.detents = [.custom { _ in 256.6 }]  // 사전 계산한 모달 높이
        presenter?.present(vc, animated: true)
    }
    
    /// 시작일 퍼블리셔
    var startDatePublisher: AnyPublisher<String?, Never> {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return stateSubject.map {
            guard let startDate = $0.dateRange?.0 else { return nil }
            return formatter.string(from: startDate)
        }
        .eraseToAnyPublisher()
    }
    
    /// 종료일 퍼블리셔
    var endDatePublisher: AnyPublisher<String?, Never> {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return stateSubject.map {
            guard let endDate = $0.dateRange?.1 else { return nil }
            return formatter.string(from: endDate)
        }
        .eraseToAnyPublisher()
    }
    
    /// 시작 시간 퍼블리셔
    var startTimePublisher: AnyPublisher<String?, Never> {
        stateSubject.map { $0.startTime }.eraseToAnyPublisher()
    }
    
    /// 종료 시간 퍼블리셔
    var endTimePublisher: AnyPublisher<String?, Never> {
        stateSubject.map { $0.endTime }.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { ScheduleForm(presenter: nil) }
