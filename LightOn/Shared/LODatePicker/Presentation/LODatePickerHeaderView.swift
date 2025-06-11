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
    
    private let dateHeaderButton = UIButton(configuration: .plain())
    
    private let previousButton = {
        var config = UIButton.Configuration.plain()
        config.image = .loDatePickerLeftArrow
        config.contentInsets = .zero
        config.imagePadding = .zero
        return UIButton(configuration: config)
    }()
    
    private let nextButton = {
        var config = UIButton.Configuration.plain()
        config.image = .loDatePickerRightArrow
        config.contentInsets = .zero
        config.imagePadding = .zero
        return UIButton(configuration: config)
    }()
    
    private let dateHeaderIconLabel = {
        let il = LOIconLabel(iconIn: .rear)
        il.isUserInteractionEnabled = false
        il.setIcon(.loDatePickerBottomArrow)
        il.setFont(.pretendard.semiBold(20))
        il.setTextColor(.loBlack)
        il.spacing = 4
        return il
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Self Configuration
        inset = .init(horizontal: 18, vertical: 4)
        distribution = .equalSpacing
        
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(previousButton)
        addArrangedSubview(dateHeaderButton)
        addArrangedSubview(nextButton)
        dateHeaderButton.addSubview(dateHeaderIconLabel)
        dateHeaderIconLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

// MARK: Binders & Publishers

extension LODatePickerHeaderView {
    func dateHeaderTextBinder(_ text: String) {
        dateHeaderIconLabel.setText(text)
    }
    
    var previousButtonTapEventPublisher: AnyPublisher<Void, Never> {
        previousButton.tapPublisher.map { _ in }.eraseToAnyPublisher()
    }
    
    var nextButtonTapEventPublisher: AnyPublisher<Void, Never> {
        nextButton.tapPublisher.map { _ in }.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { LODatePickerHeaderView() }
