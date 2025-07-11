//
//  LOSwitch.swift
//  LightOn
//
//  Created by 신정욱 on 5/2/25.
//

import UIKit

final class LOSwitch: UISwitch {
    
    // MARK: Components
    
    private weak var thumbView: UIImageView?
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawLayerMask()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        // onTintColor 설정
        onTintColor = .brand
        // offTintColor 설정
        subviews.first?.subviews.first?.backgroundColor = .assistive
        // 내부에 있는 thumbView 인스턴스 가져오기
        thumbView = subviews.first?.subviews.last?.subviews.last as? UIImageView
    }
    
    // MARK: Layer Mask
    
    private func drawLayerMask() {
        guard let thumbView else { return }
        
        let mask = CAShapeLayer()
        let radius: CGFloat = 23
        
        // thumbView.frame.origin의 기본 값이 (-6.0, -3.0)임에 유의할 것.
        let rect = CGRect(
            x: thumbView.bounds.midX-(radius/2),
            y: thumbView.frame.midY-(radius/2),
            width: radius,
            height: radius
        )
        mask.path = UIBezierPath(ovalIn: rect).cgPath
        thumbView.layer.mask = mask
    }
}

// MARK: - Preview

#Preview { LOSwitch() }
