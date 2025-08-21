//
//  TimePickerFormComponentVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/21/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class TimePickerFormComponentVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    /// 시작시간 선택 모달
    private let startModalVC = {
        let vc = TimePickerModalVC()
        vc.titleLabel.config.text = "공연 시작 시간"
        return vc
    }()
    
    /// 종료시간 선택 모달
    private let endModalVC = {
        let vc = TimePickerModalVC()
        vc.titleLabel.config.text = "공연 종료 시간"
        return vc
    }()
    
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
    
    /// 시작시간 선택 버튼
    private let startButton = {
        let button = ScheduleFormButton()
        button.iconView.image = .timer
        button._titleLabel.config.text = "00:00"
        button.setStyle(style: .idle)
        return button
    }()
    
    /// 종료시간 선택 버튼
    private let endButton = {
        let button = ScheduleFormButton()
        button.iconView.image = .timer
        button._titleLabel.config.text = "00:00"
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
        /// 시작 모달 상태
        ///
        /// timePublisher는 초기값 없어서 초기값 제공중
        let startModalState = startModalVC.isPresentedPublisher
            .withLatestFrom(startModalVC.timePublisher.prepend(nil)) { ($0, $1) }
        
        /// 종료 모달 상태
        ///
        /// timePublisher는 초기값 없어서 초기값 제공중
        let endModalState = endModalVC.isPresentedPublisher
            .withLatestFrom(endModalVC.timePublisher.prepend(nil)) { ($0, $1) }
        
        // 모달 상태 변화에 따라 버튼 스타일 및 타이틀 업데이트
        startModalState
            .sink { [weak self] in self?.updateStartButton(isPresented: $0.0, time: $0.1) }
            .store(in: &cancellables)
        
        // 모달 상태 변화에 따라 버튼 스타일 및 타이틀 업데이트
        endModalState
            .sink { [weak self] in self?.updateEndButton(isPresented: $0.0, time: $0.1) }
            .store(in: &cancellables)
        
        // 시작 시간 피커 모달 띄우기
        startButton.tapPublisher
            .sink { [weak self] in self?.presentStartModal() }
            .store(in: &cancellables)
        
        
        // 종료 시간 피커 모달 띄우기
        endButton.tapPublisher
            .sink { [weak self] in self?.presentEndModal() }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension TimePickerFormComponentVC {
    /// 모달 상태 변화에 따라 버튼 스타일 및 타이틀 업데이트
    private func updateStartButton(isPresented: Bool, time: String?) {
        let style: ScheduleFormButtonStyle
        style = isPresented ? .editing : (time == nil ? .idle : .filled)
        startButton.setStyle(style: style)
        // 시간이 존재하면 버튼 타이틀에 반영
        time.map { startButton._titleLabel.config.text = $0 }
    }
    
    /// 모달 상태 변화에 따라 버튼 스타일 및 타이틀 업데이트
    private func updateEndButton(isPresented: Bool, time: String?) {
        let style: ScheduleFormButtonStyle
        style = isPresented ? .editing : (time == nil ? .idle : .filled)
        endButton.setStyle(style: style)
        // 시간이 존재하면 버튼 타이틀에 반영
        time.map { endButton._titleLabel.config.text = $0 }
    }
    
    /// 시작 시간 피커 모달 띄우기
    /// - Note: 모달 높이를 사전에 계산된 값으로 사용중
    private func presentStartModal() {
        startModalVC.sheetPresentationController?.detents = [.custom { _ in 256.6 }]
        present(startModalVC, animated: true)
    }
    
    /// 종료 시간 피커 모달 띄우기
    /// - Note: 모달 높이를 사전에 계산된 값으로 사용중
    private func presentEndModal() {
        endModalVC.sheetPresentationController?.detents = [.custom { _ in 256.6 }]
        present(endModalVC, animated: true)
    }
    
    /// 시작 시간 퍼블리셔
    var startTimePublisher: AnyPublisher<String?, Never> {
        startModalVC.timePublisher.eraseToAnyPublisher()
    }
    
    /// 종료 시간 퍼블리셔
    var endTimePublisher: AnyPublisher<String?, Never> {
        endModalVC.timePublisher.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { TimePickerFormComponentVC() }

