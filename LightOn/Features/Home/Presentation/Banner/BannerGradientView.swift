//
//  BannerGradientView.swift
//  LightOn
//
//  Created by 신정욱 on 5/13/25.
//

import UIKit

final class BannerGradientView: UIView {
    
    // MARK: Components
    
    private let gradientLayer = CAGradientLayer()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawGradient()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: CALayer Configuration

    private func drawGradient() {
        let colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor.black.withAlphaComponent(0.4).cgColor,
        ]
        
        gradientLayer.type = .axial
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.locations = [0, 1.0]
        
        self.layer.addSublayer(gradientLayer)
    }
}
