//
//  BannerPageControl.swift
//  LightOn
//
//  Created by 신정욱 on 5/13/25.
//

import UIKit
import Combine

import CombineCocoa

final class BannerPageControl: UIPageControl {
    
    // MARK: Properties
    
    private let height: CGFloat = 18
    private let horizontalMaskWidth: CGFloat = 19.66 // 마스킹으로 가려질 너비
    private var radius: CGFloat { height/2 }
    
    override var intrinsicContentSize: CGSize {
        let base = super.intrinsicContentSize
        return CGSize(width: base.width, height: height)
    }
    
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
    
    private func setupDefaults() { backgroundColor = .black.withAlphaComponent(0.2) }
    
    // MARK: Layer Mask
    
    /// 좌우 패딩이 넓어서 마스킹 처리
    private func drawLayerMask() {
        let mask = CAShapeLayer()
        let rect = CGRect(
            x: horizontalMaskWidth/2,
            y: 0,
            width: bounds.width-horizontalMaskWidth,
            height: bounds.height
        )
        mask.path = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
        layer.mask = mask
    }
}

// MARK: Binders & Publishers

extension BannerPageControl {
    /// currentPagePublisher가 제대로 동작 안해서 있는 퍼블리셔
    var pageIndexPublisher: AnyPublisher<Int, Never> {
        self.controlEventPublisher(for: .valueChanged)
            .compactMap { [weak self] _ in self?.currentPage }
            .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { BannerPageControl() }
