//
//  SignUpCompleteVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit

import SnapKit

final class SignUpCompleteVC: TPBackableViewController {
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical)
    
    private let imageView = {
        let iv = UIImageView(image: .signUpComplete)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let closeBarButton = {
        var config = UIButton.Configuration.plain()
        config.image = .selectLikingCross
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
        
    private let nextButton = {
        let button = TPButton(style: .filled)
        button.setTitle("다음", .pretendard.bold(16))
        return button
    }()
    
    private let titleLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.bold(22)
        config.foregroundColor = .blackLO
        config.text = "회원가입을 축하드립니다!"
        config.alignment = .center
        return TPLabel(config: config)
    }()
    
    private let descriptionLabel = {
        var config = TextConfiguration()
        config.text = "라이트온과 함께\n즐거운 공연을 즐겨보세요"
        config.font = .pretendard.regular(16)
        config.foregroundColor = .blackLO
        config.alignment = .center
        config.lineHeight = 22
        
        let label = TPLabel(config: config)
        label.numberOfLines = 2
        return label
    }()

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }

    // MARK: Defaults
    
    private func setupDefaults() {
        navigationBar.rightItemHStack.addArrangedSubview(closeBarButton)
        navigationBar.rightItemHStack.addArrangedSubview(Spacer(16))
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        view.addSubview(nextButton)
        mainVStack.addArrangedSubview(imageView)
        mainVStack.addArrangedSubview(Spacer(40))
        mainVStack.addArrangedSubview(titleLabel)
        mainVStack.addArrangedSubview(Spacer(7))
        mainVStack.addArrangedSubview(descriptionLabel)
        
        mainVStack.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(contentLayoutGuide)
        }
    }
}

// MARK: - Preview

#Preview { SignUpCompleteVC() }
