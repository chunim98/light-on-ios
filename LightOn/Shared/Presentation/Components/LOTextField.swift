//
//  LOTextField.swift
//  LightOn
//
//  Created by 신정욱 on 5/11/25.
//

import UIKit
import Combine

final class LOTextField: UITextField {

    // MARK: Properties
    
    private let inset = UIEdgeInsets(horizontal: 18, vertical: 12)
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: inset)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: inset)
    }
    
    // MARK: Configuration
    
    private func configure() {
        layer.borderColor = UIColor.thumbLine.cgColor
        font = .pretendard.regular(16)
        layer.cornerRadius = 6
        layer.borderWidth = 1
        clipsToBounds = true
        textColor = .caption
    }
    
    func setPlaceHolder(_ text: String) {
        attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [.foregroundColor: UIColor.assistive]
        )
    }
}

#Preview { LOTextField() }
