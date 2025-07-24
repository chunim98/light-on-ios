//
//  MyActivityHistoryHeaderView.swift
//  LightOn
//
//  Created by 신정욱 on 7/24/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class MyActivityHistoryHeaderView: UIStackView {
    
    // MARK: Properties
    
    // MARK: Components
    
    private let buttonHStack = UIStackView()
    
    private let imageView = UIImageView(image: .activityHistoryHeaderIllust)
    
    private let summaryLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(23)
        config.foregroundColor = .loBlack
        config.paragraphSpacing = 2
        config.lineHeight = 32
        let label = LOLabel(config: config)
        label.numberOfLines = .max
        return label
    }()
    
    private let addLikingButton = {
        var titleConfig = AttrConfiguration()
        titleConfig.font = .pretendard.bold(14)
        titleConfig.foregroundColor = .white
        titleConfig.lineHeight = 32
        titleConfig.text = "취향 추가하기"
        var config = UIButton.Configuration.filled()
        config.attributedTitle = .init(config: titleConfig)
        config.contentInsets = .init(horizontal: 14)
        config.baseBackgroundColor = .brand
        config.cornerStyle = .capsule
        return UIButton(configuration: config)
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setSummaryText() // temp
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(horizontal: 18) + .init(top: 38, bottom: 24)
        backgroundColor = .xF5F0FF
        axis = .vertical
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(imageView)
        
        addArrangedSubview(summaryLabel)
        addArrangedSubview(LOSpacer(24))
        addArrangedSubview(buttonHStack)
        addArrangedSubview(LOSpacer())
        
        buttonHStack.addArrangedSubview(addLikingButton)
        buttonHStack.addArrangedSubview(LOSpacer())
        
        self.snp.makeConstraints { $0.height.equalTo(308) }
        imageView.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(21)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {}
    
    // MARK: Public Configuration
    
    func setSummaryText() {
        let name = "아이유"
        let applyCount = 15
        let place = "대학로"
        
        summaryLabel.config.text = """
        \(name)님의
        공연 참가 수는 \(applyCount)회
        주요 활동 장소는 \(place) 입니다
        """
        
        summaryLabel.addAnyAttribute(
            name: .foregroundColor,
            value: UIColor.brand,
            segment: "\(applyCount)회"
        )
        
        summaryLabel.addAnyAttribute(
            name: .foregroundColor,
            value: UIColor.brand,
            segment: place
        )
    }
}

// MARK: - Preview

#Preview { MyActivityHistoryHeaderView() }

