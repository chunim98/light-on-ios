//
//  TableContainerView.swift
//  LightOn
//
//  Created by 신정욱 on 7/11/25.
//

import UIKit

final class TableContainerView: UIStackView {
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // shadowPath로 그림자 렌더링 성능 개선
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        layer.shadowOffset = .init(width: 0, height: 5)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius  = 15
        isHidden = true
    }
    
    // MARK: Public Configuration
    
    override func addArrangedSubview(_ view: UIView) {
        view.backgroundColor = .white
        
        view.layer.borderColor = UIColor.brand.cgColor
        view.layer.borderWidth = 1
        
        view.layer.cornerRadius = 6
        view.clipsToBounds = true

        super.addArrangedSubview(view)
    }
}
