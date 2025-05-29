//
//  LoginOptionButton.swift
//  LightOn
//
//  Created by 신정욱 on 5/16/25.
//

import UIKit

final class LoginOptionButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        var titleConfig = TextConfiguration()
        titleConfig.font = .pretendard.semiBold(14)
        titleConfig.foregroundColor = .clickable
        titleConfig.lineHeight = 30
        titleConfig.text = title
        
        var config = UIButton.Configuration.plain()
        config.attributedTitle = .init(textConfig: titleConfig)
        config.contentInsets = .zero
        
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
