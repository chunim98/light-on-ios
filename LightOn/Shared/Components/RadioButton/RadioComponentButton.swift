//
//  RadioComponentButton.swift
//  LightOn
//
//  Created by 신정욱 on 5/22/25.
//

import UIKit

final class RadioComponentButton: UIButton {
    
    // MARK: Properties
    
    private let title: String
    
    // MARK: Life Cycle
    
    init(title: String, tag: Int) {
        self.title = title
        super.init(frame: .zero)
        self.tag = tag
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        var titleConfig = AttrConfiguration()
        titleConfig.alignment = .center
        titleConfig.lineHeight = 23
        titleConfig.text = title
        
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .clear
        config.contentInsets = .zero
        config.imagePadding = 6
        
        contentHorizontalAlignment = .leading
        configurationUpdateHandler = {
            if $0.isSelected {
                titleConfig.font = .pretendard.medium(16)
                titleConfig.foregroundColor = .loBlack
                
                config.attributedTitle = .init(config: titleConfig)
                config.image = .radioSelected
                
            } else {
                titleConfig.font = .pretendard.regular(16)
                titleConfig.foregroundColor = .assistive
                
                config.attributedTitle = .init(config: titleConfig)
                config.image = .radioDeselected
            }
            
            $0.configuration = config
        }
    }
}

// MARK: - Preview

#Preview { RadioComponentButton(title: "친구", tag: 0) }
#Preview {
    let button = RadioButton(isRequired: false)
    button.titles = ["인스타", "네이버 검색", "친구 추천", "추가"]
    return button
}
