//
//  LOCheckbox.swift
//  LightOn
//
//  Created by 신정욱 on 5/4/25.
//

import UIKit
import Combine

final class LOCheckbox: UIButton {
    
    // MARK: Outputs
    
    private let isCheckedSubject = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    
    private func configure() {
        self.setBackgroundImage(UIImage(named: "checkbox_checked"), for: .selected)
        self.setBackgroundImage(UIImage(named: "checkbox_unchecked"), for: .normal)
        self.addTarget(self, action: #selector(handleTapEvent), for: .touchUpInside)
    }
    
    // MARK: Override Methods
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 16, height: 16)
    }
    
    // MARK: Event Handling
    
    @objc private func handleTapEvent() {
        self.isSelected.toggle()
        self.isCheckedSubject.send(self.isSelected)
    }
}

// MARK: Publisher

extension LOCheckbox {
    var isCheckedPublisher: AnyPublisher<Bool, Never> {
        self.isCheckedSubject.eraseToAnyPublisher()
    }
}

#Preview(traits: .fixedLayout(width: 64, height: 64)) { LOCheckbox() }
