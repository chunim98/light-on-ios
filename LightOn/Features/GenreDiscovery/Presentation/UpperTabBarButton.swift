//
//  UpperTabBarButton.swift
//  LightOn
//
//  Created by 신정욱 on 7/23/25.
//

import UIKit

final class UpperTabBarButton: UIButton {
    
    // MARK: Properties
    
    var titleConfig = {
        var config = AttrConfiguration()
        config.letterSpacing = .zero
        config.alignment = .center
        config.lineHeight = 18.8
        return config
    }()
    
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
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(top: 13, bottom: 8)
        config.background.backgroundColor = .clear
        
        configurationUpdateHandler = { [weak self] in
            guard let self else { return }
            
            if $0.isSelected {
                titleConfig.font = .pretendard.bold(17)
                titleConfig.foregroundColor = .brand
                
            } else {
                titleConfig.font = .pretendard.regular(17)
                titleConfig.foregroundColor = .assistive
            }
            
            config.attributedTitle = .init(config: titleConfig)
            $0.configuration = config
        }
    }
    
    // MARK: Public Configuration
    
    func setTitle(_ title: String) {
        titleConfig.text = title
        configuration?.attributedTitle = .init(config: titleConfig)
    }
}
