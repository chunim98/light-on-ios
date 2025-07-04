//
//  RegisterPerformanceRowButton.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

import UIKit

import SnapKit

final class RegisterPerformanceRowButton: UIButton {
    
    // MARK: Properties
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: 44)
    }
    
    // MARK: Components
    
    private let mainHStack = {
        let sv = UIStackView()
        sv.isUserInteractionEnabled = false
        sv.alignment = .center
        sv.spacing = 16
        return sv
    }()
    
    private let titleVStack = UIStackView(.vertical)
    
    let _imageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.snp.makeConstraints { $0.size.equalTo(38) }
        return iv
    }()
    
    private let arrowView = {
        let iv = UIImageView(image: .myPageArrow)
        iv.contentMode = .scaleAspectFit
        iv.snp.makeConstraints { $0.size.equalTo(16) }
        return iv
    }()
    
    let _titleLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.bold(18)
        config.foregroundColor = .loBlack
        config.lineHeight = 24
        return LOLabel(config: config)
    }()
    
    let descriptionLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(14)
        config.foregroundColor = .caption
        config.lineHeight = 20
        return LOLabel(config: config)
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
    
    // MARK: Defaults
    
    private func setupDefaults() { configuration = .plain() }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(mainHStack)
        mainHStack.addArrangedSubview(_imageView)
        mainHStack.addArrangedSubview(titleVStack)
        mainHStack.addArrangedSubview(LOSpacer())
        mainHStack.addArrangedSubview(arrowView)
        
        titleVStack.addArrangedSubview(_titleLabel)
        titleVStack.addArrangedSubview(descriptionLabel)
        
        mainHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
 
}
