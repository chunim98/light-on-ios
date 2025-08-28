//
//  DatePickerFormComponentVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/28/25.
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
        // 버튼 스타일 및 타이틀 갱신
        Publishers
            .CombineLatest(modalVC.isPresentedPublisher, modalVC.datesPublisher)
            .sink { [weak self] in self?.updateButton(with: $0.0, $0.1) }
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
    ///
    /// - Parameters:
    ///   - isPresenting: 모달이 현재 표시 중인지 여부
    ///     true면 편집 상태로 간주하여 버튼을 `.editing` 스타일로 적용
    ///
    ///   - dates: 선택된 날짜 배열.
    ///     - 비어 있으면 아무것도 선택되지 않은 상태로 `.idle` 스타일 적용
    ///     - 하나 이상 있으면 항상 `[시작일, 종료일]` 형태를 가정하고 버튼 타이틀에 반영
    private func updateButton(with isPresenting: Bool, _ dates: [Date]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd"
        
        /// 모달 표시 여부 및 날짜 선택 상태에 따른 버튼 스타일 설정
        /// - isEmpty만 확인하는 dates의 개수는 항상 2개이기 때문
        let style: ScheduleFormButtonStyle
        style = isPresenting ? .editing : (dates.isEmpty ? .idle : .filled)
        startButton.setStyle(style: style)
        endButton.setStyle(style: style)
        
        // 선택된 날짜가 있으면 버튼 타이틀에 반영
        dates[safe: 0].map {
            startButton._titleLabel.config.text = formatter.string(from: $0)
        }
        dates[safe: 1].map {
            endButton._titleLabel.config.text = formatter.string(from: $0)
        }
    }
    
    /// 날짜 피커 모달 띄우기
    /// - 모달 높이를 사전에 계산된 값으로 사용중
    private func presentDatePickerModal() {
        modalVC.sheetPresentationController?.detents = [.custom { _ in 464.6 }]
        present(modalVC, animated: true)
    }
    
    /// 현재 선택된 날짜 범위를 설정
    /// - 전달받은 문자열을 `"yyyy-MM-dd"` 형식으로 파싱하여 `Date` 배열 `[시작일, 종료일]`로 변환함
    ///   (`start`나 `end`가 nil이거나 파싱에 실패하면 아무 동작도 하지 않음)
    ///
    /// - 직접 값을 주입하는 방식이라,
    ///   `datePicker`에서 사용자가 실제로 날짜를 탭했을 때 자동으로 발생하는
    ///   사이드 이펙트(페이지 이동, 선택 상태 갱신 등)를 수동으로 호출하여 동일한 흐름을 재현함
    ///   (`updateButton`, `modalVC.setDates` 호출을 통해 버튼 상태 및 상위 뷰(UI) 갱신까지 반영)
    ///
    /// - Note: 아무것도 선택되지 않은 상태를 원하면 이 메서드를 호출하지 말 것
    func setDates(start: String?, end: String?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let start, let end,
              let startDate = formatter.date(from: start),
              let endDate = formatter.date(from: end)
        else { return }
        
        let dates = [startDate, endDate]
        updateButton(with: false, dates)
        modalVC.setDates(dates) // 상위 뷰 사이드이펙트까지 재현
    }
    
    /// 시작일 퍼블리셔
    /// - yyyy-MM-dd 형식으로 포맷됨
    var startDatePublisher: AnyPublisher<String?, Never> {
        modalVC.datesPublisher.map { dates in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return dates[safe: 0].map { formatter.string(from: $0) }
        }
        .eraseToAnyPublisher()
    }
    
    /// 종료일 퍼블리셔
    /// - yyyy-MM-dd 형식으로 포맷됨
    var endDatePublisher: AnyPublisher<String?, Never> {
        modalVC.datesPublisher.map { dates in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return dates[safe: 1].map { formatter.string(from: $0) }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { DatePickerFormComponentVC() }
