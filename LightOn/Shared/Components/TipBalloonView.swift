//
//  TipBalloonView.swift
//  LightOn
//
//  Created by 신정욱 on 5/15/25.
//

import UIKit

import SnapKit

final class TipBalloonView: UIView {
    
    // MARK: Components
    
    private let mainHStack = {
        let sv = UIStackView()
        sv.inset = .init(horizontal: 18, vertical: 8)
        sv.backgroundColor = .white
        sv.layer.cornerRadius = 6
        return sv
    }()
    
    private let descriptionLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.medium(12)
        config.foregroundColor = .loBlack
        config.alignment = .center
        config.lineHeight = 16
        
        let label = LOLabel(config: config)
        label.lineBreakStrategy = .hangulWordPriority
        label.numberOfLines = .max
        return label
    }()
    
    private let triangleImageView = {
        let iv = UIImageView()
        iv.image = .loTipBalloonTriangle.withTintColor(.white)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // shadowPath로 그림자 렌더링 성능 개선
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 20
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        self.addSubview(mainHStack)
        self.addSubview(triangleImageView)
        mainHStack.addArrangedSubview(descriptionLabel)
        
        mainHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        triangleImageView.snp.makeConstraints {
            $0.top.equalTo(mainHStack.snp.bottom).offset(-3)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: Public Configuration
    
    /// 말풍선 텍스트 설정
    func setText(text: String, highlighted: String) {
        descriptionLabel.config.text = text
        descriptionLabel.addAnyAttribute(
            name: .font,
            value: UIFont.pretendard.bold(12)!,
            segment: highlighted
        )
        descriptionLabel.addAnyAttribute(
            name: .foregroundColor,
            value: UIColor.brand,
            segment: highlighted
        )
    }
}
