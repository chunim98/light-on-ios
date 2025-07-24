//
//  LinkButton.swift
//  LightOn
//
//  Created by 신정욱 on 6/25/25.
//

import UIKit

final class LinkButton: UIButton {
    
    // MARK: Properties
    
    private var config = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero
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
    
    private func setupDefaults() { configuration = config }
    
    // MARK: Public Configuration
    
    func setTitle(title: String, font: UIFont, color: UIColor) {
        var titleConfig = AttrConfiguration()
        titleConfig.underlineStyle = .single
        titleConfig.underlineColor = color
        titleConfig.foregroundColor = color
        titleConfig.text = title
        titleConfig.font = font
        
        config.attributedTitle = .init(config: titleConfig)
        
        configuration = config
    }
}
