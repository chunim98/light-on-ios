//
//  LOFormValidationCaptionView.swift
//  LightOn
//
//  Created by 신정욱 on 5/18/25.
//

import UIKit
import Combine

import SnapKit

final class LOFormValidationCaptionView: LOIconLabel {
    
    // MARK: Properties
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: 18)
    }
    
    // MARK: Life Cycle
    
    init() {
        super.init(iconIn: .front)
        setupDefaults()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        setFont(.pretendard.regular(12))
        inset = .init(leading: 2)
        isHidden = true
        spacing = 3
    }
    
    // MARK: Public Configuration
    
    func setInvalidCaption(_ text: String) {
        setIcon(.formFieldExclamation)
        setText(text)
        setColor(.destructive)
        isHidden = false
    }
    
    func setValidCaption(_ text: String) {
        setIcon(.formFieldCheck)
        setText(text)
        setColor(.brand)
        isHidden = false
    }
}
