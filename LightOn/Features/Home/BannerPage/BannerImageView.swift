//
//  BannerImageView.swift
//  LightOn
//
//  Created by 신정욱 on 7/23/25.
//

import UIKit

final class BannerImageView: UIImageView {
    
    // MARK: Components
    
    private let gradientLayer = {
        let colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor.black.withAlphaComponent(0.4).cgColor,
        ]
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        layer.locations = [0, 1.0]
        layer.colors = colors
        layer.type = .axial
        return layer
    }()
    
    // MARK: Life Cycle
    
    init() {
        super.init(frame: .zero)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        contentMode = .scaleAspectFill
        backgroundColor = .xC5C5C5
        clipsToBounds = true
    }
    
    // MARK: Layout
    
    private func setupLayout() { layer.addSublayer(gradientLayer) }
}
