//
//  BackBarButton.swift
//  LightOn
//
//  Created by 신정욱 on 5/14/25.
//

import UIKit

final class BackBarButton: UIButton {
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var config = UIButton.Configuration.plain()
        config.image = .backBarButtonArrow.withTintColor(.loBlack)
        config.contentInsets = .zero
        config.imagePadding = .zero
        
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
