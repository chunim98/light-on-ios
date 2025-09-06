//
//  RegisterConcertConfirmAlertVC.swift
//  LightOn
//
//  Created by 신정욱 on 9/6/25.
//

import UIKit

final class RegisterConcertConfirmAlertVC: BaseAlertVC {
    
    // MARK: Components
    
    private let buttonHStack = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    private let captionLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(14)
        config.foregroundColor = .infoText
        config.alignment = .center
        config.lineHeight = 22
        config.text = "심사는 영업일 기준 1~2일 소요 예정"
        let label = LOLabel(config: config)
        label.numberOfLines = 0 // 무제한
        return label
    }()
    
    let acceptButton = {
        let button = LOButton(style: .filled)
        button.setTitle("등록", .pretendard.semiBold(16))
        return button
    }()
    
    let cancelButton = {
        let button = LOButton(style: .bordered)
        button.setTitle("취소", .pretendard.regular(16))
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        titleLabel.config.text = "공연을 등록하시겠습니까?"
        descriptionLabel.config.text = """
        작성하신 내용으로\u{2028}공연을 등록하시겠습니까?
        등록한 공연은 심사 후\u{2028}최종 등록 될 예정입니다.
        """
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.addArrangedSubview(LOSpacer(8))
        contentVStack.addArrangedSubview(captionLabel)
        contentVStack.addArrangedSubview(LOSpacer(28))
        contentVStack.addArrangedSubview(buttonHStack)
        
        buttonHStack.addArrangedSubview(cancelButton)
        buttonHStack.addArrangedSubview(acceptButton)
    }
}
