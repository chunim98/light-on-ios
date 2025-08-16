//
//  LoginInfoVC.swift
//  LightOn
//
//  Created by 신정욱 on 6/26/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class LoginInfoVC: CombineVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = MyPageDI.shared.makeLoginInfoVM()
    
    // MARK: Containers
    
    private let mainVStack = UIStackView(
        .vertical, spacing: 16, inset: .init(horizontal: 18, vertical: 30)
    )
    
    private let userInfoHStack = UIStackView(alignment: .center, spacing: 12)
    
    private let buttonsHStack = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    private let infoDetailVStack = UIStackView(.vertical, spacing: 4)
    
    private let nameHStack = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(18)
        config.foregroundColor = .loBlack
        config.lineHeight = 17
        config.text = "님 반갑습니다."
        let label = LOLabel(config: config)
        
        let sv = UIStackView()
        sv.addArrangedSubview(label)
        return sv
    }()
    
    // MARK: Components
    
    private let profileImageView = {
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
    
    private let nameLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(18)
        config.foregroundColor = .brand
        config.lineHeight = 17
        return LOLabel(config: config)
    }()
    
    private let idLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .xA9A9A9
        config.lineHeight = 17
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { view.backgroundColor = .xF5F0FF }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(userInfoHStack)
        mainVStack.addArrangedSubview(buttonsHStack)
        
        userInfoHStack.addArrangedSubview(profileImageView)
        userInfoHStack.addArrangedSubview(infoDetailVStack)
        userInfoHStack.addArrangedSubview(LOSpacer())
        userInfoHStack.addSubview(settingsButton)
        
        buttonsHStack.addArrangedSubview(activityHistotyButton)
        buttonsHStack.addArrangedSubview(performanceRegisterButton)
        
        infoDetailVStack.addArrangedSubview(nameHStack)
        infoDetailVStack.addArrangedSubview(idLabel)
        
        nameHStack.insertArrangedSubview(nameLabel, at: 0)
        
        mainVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        settingsButton.snp.makeConstraints { $0.top.trailing.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let loginEvent = SessionManager.shared.loginStatePublisher
            .compactMap { $0 == .login ? Void() : nil }
            .eraseToAnyPublisher()
        
        let trigger = Publishers
            .Merge(viewDidAppearPublisher, loginEvent)
            .eraseToAnyPublisher()
        
        let input = LoginInfoVM.Input(trigger: trigger)
        let output = vm.transform(input)
        
        output.myInfo
            .sink { [weak self] in
                self?.nameLabel.config.text = $0.name
                self?.idLabel.config.text = $0.id
            }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { LoginInfoVC() }
