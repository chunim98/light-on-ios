//
//  PolicyDetailAlert+TextView.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit

extension PolicyDetailAlert {
final class TextView: UITextView {
    
    // MARK: Life Cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        textContainerInset = .init(horizontal: 12 , vertical: 18)
        textContainer.lineFragmentPadding = .zero // NSTextContainer 여백 제거
        backgroundColor = .background
        isSelectable = false
        isEditable = false
    }
    
    // MARK: Public Configuration
    
    func setText(_ text: String) {
        // 리스트가 필요하면 NSTextList 살펴볼 것.
        var config = TextConfiguration()
        config.font = .pretendard.regular(14)
        config.foregroundColor = .caption
        config.paragraphSpacing = 8
        config.lineHeight = 21
        config.text = text
        
        attributedText = .init(textConfig: config)
    }
}
}
