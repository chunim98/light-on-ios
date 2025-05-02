//
//  LOAlertVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/2/25.
//

import UIKit

import SnapKit

final class LOAlertVC: UIViewController {
    
    // MARK: Components
    
    private let contentView = {
        let sv = UIStackView()
        sv.spacing = 28
        sv.axis = .vertical
        sv.clipsToBounds = true
        sv.layer.cornerRadius = 8
        sv.backgroundColor = .white
        sv.inset = .init(horizontal: 18, vertical: 28)
        return sv
    }()
    
    private let messageContainer = UIStackView(axis: .vertical, spacing: 8)
    
    private let titleLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "제목" // temp
        return label
    }()
    
    private let bodyLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "이건 일단 내용입니다.\n딱히 뭐 적을 게 없네여.." // temp
        return label
    }()
    
    private let buttonContainer = UIStackView(axis: .horizontal, spacing: 8)
    
    private let cancelButton = {
        var config = UIButton.Configuration.lightOn(.bordered)
        config.attributedTitle = AttributedString("취소", attributes: .init()) // temp
        return UIButton(configuration: config)
    }()
    
    private let acceptButton = {
        var config = UIButton.Configuration.lightOn(.filled)
        config.attributedTitle = AttributedString("확인", attributes: .bold16) // temp
        return UIButton(configuration: config)
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.6)
        setAutoLayout()
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        view.addSubview(contentView)
        contentView.addArrangedSubview(messageContainer)
        contentView.addArrangedSubview(buttonContainer)
        messageContainer.addArrangedSubview(titleLabel)
        messageContainer.addArrangedSubview(bodyLabel)
        buttonContainer.addArrangedSubview(cancelButton)
        buttonContainer.addArrangedSubview(acceptButton)
        
        contentView.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(345)
        }
        buttonContainer.snp.makeConstraints { $0.height.equalTo(45) }
    }
}

#Preview { LOAlertVC() }
