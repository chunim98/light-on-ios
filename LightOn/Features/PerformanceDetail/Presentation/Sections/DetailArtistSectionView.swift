//
//  DetailArtistSectionView.swift
//  LightOn
//
//  Created by 신정욱 on 6/25/25.
//

import UIKit

import SnapKit

final class DetailArtistSectionView: UIStackView {
    
    // MARK: Components
    
    private let nameHStack = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .caption
        config.text = "아티스트 명"
        
        let label = LOLabel(config: config)
        label.snp.makeConstraints { $0.width.equalTo(90) }
        
        let sv = UIStackView()
        sv.spacing = 12
        sv.addArrangedSubview(label)
        return sv
    }()
    
    private let descriptionHStack = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .caption
        config.text = "아티스트 소개"
        
        let label = LOLabel(config: config)
        label.snp.makeConstraints { $0.width.equalTo(90) }
        
        let sv = UIStackView()
        sv.alignment = .top
        sv.spacing = 12
        sv.addArrangedSubview(label)
        return sv
    }()
    
    private let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(23)
        config.foregroundColor = .loBlack
        config.text = "아티스트 정보"
        return LOLabel(config: config)
    }()
    
    let descriptionLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(16)
        config.foregroundColor = .loBlack
        config.paragraphSpacing = 8
        config.lineHeight = 23
        config.text =
        """
        라이트 온은 홍익대학교 동아리 출신으로 이루어진 2022년 대뷔한 신입 밴드로 ‘일탈’이라는 곡을 통해 많은 팬덤을 보유한 4인조 밴드 그룹 입니다.
        """ // temp
        let label = LOLabel(config: config)
        label.numberOfLines = .max
        return label
    }()
    
    let artistButton = {
        let button = LinkButton()
        button.setTitle(
            title:  "Light ON (라이트 온)", // temp
            font:   .pretendard.regular(16),
            color:  .brand
        )
        return button
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(horizontal: 18, vertical: 40)
        axis = .vertical
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(LOSpacer(16))
        addArrangedSubview(nameHStack)
        addArrangedSubview(LOSpacer(10))
        addArrangedSubview(descriptionHStack)
        
        nameHStack.addArrangedSubview(artistButton)
        nameHStack.addArrangedSubview(LOSpacer())
        
        descriptionHStack.addArrangedSubview(descriptionLabel)
    }
}

// MARK: - Preview

#Preview { DetailArtistSectionView() }
