//
//  DatePickerModalVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/28/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class DatePickerModalVC: ModalVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let pickerVStack = {
        let sv = UIStackView(.vertical)
        sv.inset = .init(horizontal: 18)
        sv.spacing = 20
        sv.snp.makeConstraints { $0.height.equalTo(318) }
        return sv
    }()
    
    private let headerView = LODatePickerHeaderView()
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
        contentVStack.addArrangedSubview(pickerVStack)
        contentVStack.addArrangedSubview(LOSpacer(20))
        contentVStack.addArrangedSubview(confirmButton)
        contentVStack.addArrangedSubview(LOSpacer(10))
        
        pickerVStack.addArrangedSubview(headerView)
        pickerVStack.addArrangedSubview(datePicker)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 모달이 닫힌 상태에서 값 주입 시 셀이 갱신되지 않으므로
        // 레이아웃 완료 시점에 reloadData()로 강제 갱신
        viewDidLayoutSubviewsPublisher
            .sink { [weak self] in self?.datePicker.reloadData() }
            .store(in: &cancellables)
        
        // 선택한 날짜 범위로 모달 상태 갱신
        datePicker.datesPublisher
            .sink { [weak self] in self?.updateUI($0) }
            .store(in: &cancellables)
        
        // 현재 페이지 날짜로 헤더 타이틀 설정
        datePicker.pagePublisher
            .sink { [weak self] in self?.headerView.setTitle(with: $0) }
            .store(in: &cancellables)
        
        // 다음 페이지(월 단위)로 이동
        headerView.nextTapPublisher
            .sink { [weak self] in self?.datePicker.goNextPage() }
            .store(in: &cancellables)
        
        // 이전 페이지(월 단위)로 이동
        headerView.previousTapPublisher
            .sink { [weak self] in self?.datePicker.goPreviousPage() }
            .store(in: &cancellables)
        
        // 확인 버튼 탭, 창 닫기
        confirmButton.tapPublisher
            .sink { [weak self] in self?.dismiss(animated: true) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension DatePickerModalVC {
    /// 선택한 날짜 범위로 모달 상태 갱신
    private func updateUI(_ dates: [Date]) {
        titleLabel.config.text = dates.isEmpty ? "공연 시작일 선택" : "공연 종료일 선택"
        confirmButton.isEnabled = !dates.isEmpty
    }
    
    /// 현재 선택된 날짜 범위를 설정
    /// - 배열에 날짜가 하나만 있으면 시작·종료가 같은 "단일 구간"으로 간주하여
    ///   같은 값을 두 번 넣어 `[시작일, 종료일]` 형태의 배열을 보장함
    ///
    /// - 직접 값을 주입하는 방식이라, `datePicker`에서 사용자가 실제로 날짜를 탭했을 때
    ///   자동으로 발생하는 사이드 이펙트(페이지 이동, 선택 상태 갱신 등)를
    ///   수동으로 호출하여 동일한 흐름을 재현함
    ///   (`updatePage`, `updateDates`, `updateUI` 호출)
    ///
    /// - Note: 아무것도 선택되지 않은 상태를 원하면 이 메서드를 호출하지 말 것
    func setDates(_ dates: [Date]) {
        guard !dates.isEmpty else { return }
        let normalized = dates.count == 1 ? (dates+dates) : dates
        datePicker.updatePage(normalized.last!) // 가드문에서 이미 검사함
        datePicker.updateDates(normalized)
        updateUI(normalized)
    }
    
    /// 모달 표시 여부 퍼블리셔
    var isPresentedPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            viewWillAppearPublisher.map { true },
            viewWillDisappearPublisher.map { false }
        )
        .eraseToAnyPublisher()
    }
    
    /// 선택된 날짜 범위 퍼블리셔
    /// - 확인 버튼을 눌려야 선택된 값이 방출됨
    var datesPublisher: AnyPublisher<[Date], Never> {
        confirmButton.tapPublisher
            .withLatestFrom(datePicker.datesPublisher)
            .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { DatePickerModalVC() }
