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
        
        var config = UIButton.Configuration.plain()
        config.attributedTitle = .init(title, .pretendard.semiBold(14))
        config.baseForegroundColor = .clickable
        config.contentInsets = .zero
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview { LoginOptionButton(title: "회원가입") }
