//
//  DetailImageView.swift
//  LightOn
//
//  Created by 신정욱 on 6/25/25.
//

import UIKit

final class DetailImageView: UIImageView {
    
    // MARK: Components
    
    private let gradientLayer = {
        let colors = [
            UIColor.white.withAlphaComponent(1.0).cgColor,
            UIColor.white.withAlphaComponent(0.0).cgColor,
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
        gradientLayer.frame = .init(x: 0, y: 0, width: bounds.width, height: 57)
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { contentMode = .scaleAspectFill }
    
    // MARK: Layout
    
    private func setupLayout() { layer.addSublayer(gradientLayer) }
}
