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
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 27, height: 27)
    }
    
    // MARK: Life Cycle
    
    init(image: UIImage) {
        super.init(frame: .zero)
        config.image = image.withTintColor(.loBlack)
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Configuration

    func setImage(_ image: UIImage) {
        config.image = image.withTintColor(.loBlack)
        self.configuration = config
    }
}
