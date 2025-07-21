//
//  MapBaseModalView.swift
//  LightOn
//
//  Created by 신정욱 on 7/18/25.
//

import UIKit

import SnapKit

class MapBaseModalView: UIView {
    
    // MARK: Components
    
    let contentView = {
        let sv = UIStackView(.vertical)
        sv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        sv.layer.cornerRadius = 10
        sv.clipsToBounds = true
        sv.backgroundColor = .white
        return sv
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath    // 그림자 렌더링 성능 개선
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        // 그림자 설정
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.15
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(contentView)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
