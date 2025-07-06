//
//  Checkbox.swift
//  LightOn
//
//  Created by 신정욱 on 5/4/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class Checkbox: UIButton {
    
    // MARK: Properties
    
    var titleConfig = AttrConfiguration() { didSet {
        configuration?.attributedTitle = .init(config: titleConfig)
    } }

    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        titleConfig.font = .pretendard.regular(14)
        titleConfig.foregroundColor = .caption
        titleConfig.lineHeight = 23
        
        configuration = UIButton.Configuration.filled()
        configuration?.attributedTitle = .init(config: titleConfig)
        configuration?.baseBackgroundColor = .clear
        configuration?.imagePlacement = .leading
        configuration?.contentInsets = .zero
        configuration?.imagePadding = 6
        
        configurationUpdateHandler = {
            $0.configuration?.image = $0.isSelected ? .checkboxChecked : .checkboxUnchecked
        }

        addTarget(self, action: #selector(handleTapEvent), for: .touchUpInside)
    }

    // MARK: Event Handling
    
    @objc private func handleTapEvent() { self.isSelected.toggle() }
}

// MARK: Binders & Publishers

extension Checkbox {
    /// 선택 상태 퍼블리셔
    var isSelectedPublisher: AnyPublisher<Bool, Never> {
        self.tapPublisher
            .compactMap { [weak self] in self?.isSelected }
            .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview(traits: .fixedLayout(width: 64, height: 64)) {
    let box = Checkbox()
    box.titleConfig.text = "이게 되네"
    return box
}
