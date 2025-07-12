//
//  TapStackView.swift
//  LightOn
//
//  Created by 신정욱 on 7/12/25.
//

import UIKit
import Combine

import CombineCocoa

final class TapStackView: UIStackView {
    
    // MARK: Components
    
    private let tapGesture = {
        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { addGestureRecognizer(tapGesture) }
}

// MARK: Binders & Publishers

extension TapStackView {
    /// 탭 제스처 퍼블리셔
    var tapGesturePublisher: AnyPublisher<UITapGestureRecognizer, Never> {
        tapGesture.tapPublisher
    }
}
