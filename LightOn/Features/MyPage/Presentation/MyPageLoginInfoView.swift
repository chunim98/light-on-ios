//
//  MyPageLoginInfoView.swift
//  LightOn
//
//  Created by 신정욱 on 6/26/25.
//

import UIKit

import SnapKit

final class MyPageLoginInfoView: UIStackView {

    // MARK: Components
    
    private let userInfoHStack = UIStackView(alignment: .center, spacing: 12)
    private let buttonsHStack = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    private let infoDetailVStack = UIStackView(.vertical, spacing: 4)
    private let nameHStack = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(18)
        config.foregroundColor = .loBlack
        config.lineHeight = 17
        config.text = "님 반갑습니다."
        let label = LOLabel(config: config)
        
        let sv = UIStackView()
        sv.addArrangedSubview(label)
        return sv
    }()
    
    let profileImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        
        iv.layer.borderColor = UIColor.assistive.cgColor
        iv.layer.borderWidth = 1
        
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        
        iv.snp.makeConstraints { $0.size.equalTo(50) }
        return iv
    }()
    
    let nameLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.bold(18)
        config.foregroundColor = .brand
        config.lineHeight = 17
        config.text = "신정욱" // temp
        return LOLabel(config: config)
    }()
    
    let idLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .xA9A9A9
        config.lineHeight = 17
        config.text = "chunnim98" // temp
        return LOLabel(config: config)
    }()
    
    let settingsButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero
        config.image = .myPageGear
        return UIButton(configuration: config)
    }()
    
    let activityHistotyButton = {
        let button = LOButton(style: .borderedTinted)
        button.setTitle("내 활동 내역", .pretendard.semiBold(16))
        return button
    }()
    
    let performanceRegisterButton = {
        let button = LOButton(style: .filled)
        button.setTitle("공연 등록", .pretendard.semiBold(16))
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
        inset = .init(horizontal: 18, vertical: 30)
        backgroundColor = .xF5F0FF
        axis = .vertical
        spacing = 16
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(userInfoHStack)
        addArrangedSubview(buttonsHStack)
        
        userInfoHStack.addArrangedSubview(profileImageView)
        userInfoHStack.addArrangedSubview(infoDetailVStack)
        userInfoHStack.addArrangedSubview(LOSpacer())
        userInfoHStack.addSubview(settingsButton)
        
        buttonsHStack.addArrangedSubview(activityHistotyButton)
        buttonsHStack.addArrangedSubview(performanceRegisterButton)
        
        infoDetailVStack.addArrangedSubview(nameHStack)
        infoDetailVStack.addArrangedSubview(idLabel)
        
        nameHStack.insertArrangedSubview(nameLabel, at: 0)
        
        settingsButton.snp.makeConstraints { $0.top.trailing.equalToSuperview() }
    }
}

// MARK: - Preview

#Preview { MyPageLoginInfoView() }
