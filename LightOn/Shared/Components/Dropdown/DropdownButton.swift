//
//  DropdownButton.swift
//  LightOn
//
//  Created by 신정욱 on 7/11/25.
//

import UIKit

final class DropdownButton: UIButton {
    
    // MARK: Enum
    
    enum State { case idle, filled(String?) }
    
    // MARK: Properties
    
    private let defaultTitle: String
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: 47)
    }
    
    // MARK: Life Cycle
    
    init(defaultTitle: String) {
        self.defaultTitle = defaultTitle
        super.init(frame: .zero)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        var config = UIButton.Configuration.filled()
        config.contentInsets = .init(horizontal: 18)
        config.baseBackgroundColor = .white
        config.imagePlacement = .trailing
        config.image = .signUpArrow
        
        config.background.strokeWidth = 1
        
        config.background.cornerRadius = 6
        config.cornerStyle = .fixed
        
        configuration = config
        contentHorizontalAlignment = .fill
        
        setState(.idle)
    }
    
    // MARK: Public Configuration
    
    func setState(_ state: State) {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.lineHeight = 23
        
        switch state {
        case .idle:
            configuration?.image = configuration?.image?.withTintColor(.assistive)
            configuration?.background.strokeColor = .thumbLine
            config.foregroundColor = .assistive
            config.text = defaultTitle
            
        case .filled(let title):
            configuration?.image = configuration?.image?.withTintColor(.loBlack)
            configuration?.background.strokeColor = .loBlack
            config.foregroundColor = .loBlack
            config.text = title
        }
        
        configuration?.attributedTitle = .init(config: config)
    }
}
