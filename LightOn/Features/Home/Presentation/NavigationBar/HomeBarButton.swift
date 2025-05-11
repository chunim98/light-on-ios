//
//  HomeBarButton.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

final class HomeBarButton: UIButton {
    
    // MARK: Properties
    
    private var config = {
        var config = UIButton.Configuration.plain()
        config.imagePadding = .zero
        return config
    }()
    
    // MARK: Initializer
    
    init(image: UIImage) {
        super.init(frame: .zero)
        config.image = image.withTintColor(.loBlack)
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    
    func setImage(_ image: UIImage) {
        config.image = image.withTintColor(.loBlack)
        self.configuration = config
    }
    
    // MARK: Override
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 27, height: 27)
    }
}
