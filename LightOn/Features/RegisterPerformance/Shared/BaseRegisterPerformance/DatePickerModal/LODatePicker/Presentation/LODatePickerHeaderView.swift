//
//  LODatePickerHeaderView.swift
//  LightOn
//
//  Created by 신정욱 on 5/14/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class LODatePickerHeaderView: UIStackView {
    
    // MARK: Components
    
    private let dateButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero
        return UIButton(configuration: config)
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
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(vertical: 4)
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
    /// 날짜 버튼 타이틀 설정
    func setTitle(_ text: String) {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(20)
        config.foregroundColor = .loBlack
        config.lineHeight = 20
        config.text = text
        dateButton.configuration?.attributedTitle = .init(config: config)
    }
    
    /// 이전 버튼 탭 퍼블리셔
    var previousTapPublisher: AnyPublisher<Void, Never> {
        previousButton.tapPublisher
    }
    
    /// 다음 버튼 탭 퍼블리셔
    var nextTapPublisher: AnyPublisher<Void, Never> {
        nextButton.tapPublisher
    }
}

// MARK: - Preview

#Preview { LODatePickerHeaderView() }
