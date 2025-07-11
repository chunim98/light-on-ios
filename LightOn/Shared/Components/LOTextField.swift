//
//  LOTextField.swift
//  LightOn
//
//  Created by 신정욱 on 5/11/25.
//

import UIKit

class LOTextField: UITextField {
    
    // MARK: Properties
    
    private let inset = UIEdgeInsets(horizontal: 18, vertical: 12)
    
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
        autocapitalizationType = .none  // 자동 대문자 비활성화
        textContentType = .oneTimeCode  // 강력한 비번 생성 방지
        
        font = .pretendard.regular(16)
        textColor = .caption
        
        layer.borderColor = UIColor.thumbLine.cgColor
        layer.borderWidth = 1
        
        backgroundColor = .white
        layer.cornerRadius = 6
        clipsToBounds = true
        
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    // MARK: Overrides
    
    override func textRect(forBounds bounds: CGRect) -> CGRect { bounds.inset(by: inset) }
    override func editingRect(forBounds bounds: CGRect) -> CGRect { bounds.inset(by: inset) }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect { bounds.inset(by: inset) }
    
    // MARK: Public Configuration
    
    func setPlaceHolder(_ text: String) {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .assistive
        config.lineHeight = 23
        config.text = text
        
        attributedPlaceholder = .init(config: config)
    }
}

// MARK: - Preview

#Preview { LOTextField() }

