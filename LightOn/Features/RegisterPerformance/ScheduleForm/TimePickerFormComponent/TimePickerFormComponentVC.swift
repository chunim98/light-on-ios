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
    
    // MARK: State
    
    struct State {
        // 시작, 종료 시간
        var startTime: String?
        var endTime: String?
        // 모달 표시 여부
        var isStartPresenting: Bool = false
        var isEndPresenting: Bool = false
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Subjects
    
    /// 시작 시간 업데이트 서브젝트
    ///
    /// 입력 목적
    private let updateStartSubject = PassthroughSubject<String?, Never>()
    
    /// 종료 시간 업데이트 서브젝트
    ///
    /// 입력 목적
    private let updateEndSubject = PassthroughSubject<String?, Never>()
    
    // MARK: Components
    
    /// 시작시간 선택 모달
    let startModalVC = {
        let vc = TimePickerModalVC()
        vc.titleLabel.config.text = "공연 시작 시간"
        return vc
    }()
    
    /// 종료시간 선택 모달
    let endModalVC = {
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
        /// 모달과 버튼의 상태를 한곳에서 관리하기 위한 SOT 서브젝트
        let stateSubject = CurrentValueSubject<State, Never>(.init())
        
        // 모달 표시여부 갱신
        startModalVC.isPresentedPublisher
            .sink { stateSubject.value.isStartPresenting = $0 }
            .store(in: &cancellables)
        
        // 모달 표시여부 갱신
        endModalVC.isPresentedPublisher
            .sink { stateSubject.value.isEndPresenting = $0 }
            .store(in: &cancellables)
        
        // 모달에서 선택된 값과 외부에서 요청된 날짜 범위 변경 이벤트를 병합해 상태 반영
        Publishers
            .Merge(
                updateStartSubject.eraseToAnyPublisher(),
                startModalVC.timePublisher
            )
            .sink { stateSubject.value.startTime = $0 }
            .store(in: &cancellables)
        
        // 모달에서 선택된 값과 외부에서 요청된 날짜 범위 변경 이벤트를 병합해 상태 반영
        Publishers
            .Merge(
                updateEndSubject.eraseToAnyPublisher(),
                endModalVC.timePublisher
            )
            .sink { stateSubject.value.endTime = $0 }
            .store(in: &cancellables)
        
        // 모달 상태 변화에 따라 버튼 스타일 및 타이틀 업데이트
        stateSubject
            .sink { [weak self] in
                self?.startModalVC.updateTime($0.startTime)
                self?.endModalVC.updateTime($0.endTime)
                self?.updateStartButton(with: $0)
                self?.updateEndButton(with: $0)
            }
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
    private func updateStartButton(with state: State) {
        let isPresenting = state.isStartPresenting
        let time = state.startTime
        let style: ScheduleFormButtonStyle
        style = isPresenting ? .editing : (time == nil ? .idle : .filled)
        startButton.setStyle(style: style)
        // 시간이 존재하면 버튼 타이틀에 반영
        time.map { startButton._titleLabel.config.text = $0 }
    }
    
    /// 모달 상태 변화에 따라 버튼 스타일 및 타이틀 업데이트
    private func updateEndButton(with state: State) {
        let isPresenting = state.isEndPresenting
        let time = state.endTime
        let style: ScheduleFormButtonStyle
        style = isPresenting ? .editing : (time == nil ? .idle : .filled)
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
    
    /// 시작 시간 업데이트
    ///
    /// 직접 상태를 수정하지 않고, Subject를 통해 변경 요청을 전달함
    func updateStartTime(_ time: String?) {
        guard let comps = time?.split(separator: ":"),
              comps.count >= 2
        else { return }
        updateStartSubject.send("\(comps[0]):\(comps[1])")
    }
    
    /// 종료 시간 업데이트
    ///
    /// 직접 상태를 수정하지 않고, Subject를 통해 변경 요청을 전달함
    func updateEndTime(_ time: String?) {
        guard let comps = time?.split(separator: ":"),
              comps.count >= 2
        else { return }
        updateEndSubject.send("\(comps[0]):\(comps[1])")
    }
}

// MARK: - Preview

#Preview { TimePickerFormComponentVC() }

