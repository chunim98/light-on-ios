//
//  LODatePickerHeaderView.swift
//  LightOn
//
//  Created by 신정욱 on 5/14/25.
//

import UIKit
import Combine

import SnapKit

final class LODatePickerHeaderView: UIStackView {
    
    // MARK: Components
    
    private let dateButton = {
        var config = UIButton.Configuration.plain()
        config.image = .loDatePickerBottomArrow
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.contentInsets = .zero
        
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private let previousButton = {
        var config = UIButton.Configuration.plain()
        config.image = .loDatePickerLeftArrow
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    private let nextButton = {
        var config = UIButton.Configuration.plain()
        config.image = .loDatePickerRightArrow
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        bindDateHeaderText("2025년 5월")
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(horizontal: 18, vertical: 4)
        distribution = .equalSpacing
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(previousButton)
        addArrangedSubview(dateButton)
        addArrangedSubview(nextButton)
    }
}

// MARK: Binders & Publishers

extension LODatePickerHeaderView {
    /// 날짜 버튼 타이틀 바인딩
    func bindDateHeaderText(_ text: String) {
        var config = TextConfiguration()
        config.font = .pretendard.semiBold(20)
        config.foregroundColor = .loBlack
        config.lineHeight = 20
        config.text = text
        dateButton.configuration?.attributedTitle = .init(textConfig: config)
    }
    
    var previousTapPublisher: AnyPublisher<Void, Never> {
        previousButton.tapPublisher.map { _ in }.eraseToAnyPublisher()
    }
    
    var nextTapPublisher: AnyPublisher<Void, Never> {
        nextButton.tapPublisher.map { _ in }.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { LODatePickerHeaderView() }
