//
//  TimePickerModalVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class TimePickerModalVC: ModalVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let timePicker = TimePickerView()
    
    private let confirmButton = {
        let button = LOButton(style: .filled, height: 46)
        button.setTitle("확인", .pretendard.semiBold(16))
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
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.addArrangedSubview(LOSpacer(20))
        contentVStack.addArrangedSubview(timePicker)
        contentVStack.addArrangedSubview(LOSpacer(34))
        contentVStack.addArrangedSubview(confirmButton)
        contentVStack.addArrangedSubview(LOSpacer(10))
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        confirmButton.tapPublisher
            .sink { [weak self] in self?.dismiss(animated: true) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension TimePickerModalVC {
    /// 선택한 시간 업데이트
    func updateTime(_ time: String?) {
        timePicker.updateTime(time)
    }
    
    /// 선택한 시간 퍼블리셔
    var timePublisher: AnyPublisher<String?, Never> {
        confirmButton.tapPublisher
            .withLatestFrom(timePicker.timePublisher) { _, time in time }
            .eraseToAnyPublisher()
    }
    
    /// 모달 표시 상태 퍼블리셔
    var isPresentedPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            viewWillAppearPublisher.map { true },
            viewWillDisappearPublisher.map { false }
        )
        .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { TimePickerModalVC() }
