//
//  PerformanceScheduleForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/6/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class PerformanceScheduleForm: BaseForm {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
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
    
    private let startDateButton = {
        let button = PerformanceScheduleButton()
        button.iconView.image = .calendar
        button._titleLabel.config.text = "00/00/00" // temp
        button.bindStyle(style: .empty) // temp
        return button
    }()
    
    private let endDateButton = {
        let button = PerformanceScheduleButton()
        button.iconView.image = .calendar
        button._titleLabel.config.text = "00/00/00" // temp
        button.bindStyle(style: .empty) // temp
        return button
    }()
    
    private let startTimeButton = {
        let button = PerformanceScheduleButton()
        button.iconView.image = .timer
        button._titleLabel.config.text = "00:00" // temp
        button.bindStyle(style: .empty) // temp
        return button
    }()
    
    private let endTimeButton = {
        let button = PerformanceScheduleButton()
        button.iconView.image = .timer
        button._titleLabel.config.text = "00:00" // temp
        button.bindStyle(style: .empty) // temp
        return button
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
    }
}

// MARK: - Preview

#Preview { PerformanceScheduleForm() }
