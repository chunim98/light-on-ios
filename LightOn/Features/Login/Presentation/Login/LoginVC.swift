//
//  LoginVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/16/25.
//

import UIKit
import Combine

import SnapKit

final class LoginVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, alignment: .center, spacing: 23)
    
    private let backBarButton = BackBarButton()
    private let logoImageView = UIImageView(image: .loginLogo)
    private let loginFormFieldsView = LoginFormsView()
    private let mainLoginButton = MainLoginButton()
    private let loginElseDivider = LoginElseDivider()
    private let socialLoginButtonsView = SocialLoginButtonsView()
    private let loginOptionButtonsView = LoginOptionButtonsView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
    }
    
    // MARK: NavigationBar
    
    private func setupNavigationBar() {
        let barBuilder = ComposableNavigationBarBuilder(base: self)
        // interactivePopGesture 복구
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        barBuilder.setLeftBarLayout(leadingInset: 16)
        barBuilder.addLeftBarItem(backBarButton)
        barBuilder.build()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(logoImageView)
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(loginFormFieldsView)
        mainVStack.addArrangedSubview(mainLoginButton)
        mainVStack.addArrangedSubview(loginElseDivider)
        mainVStack.addArrangedSubview(socialLoginButtonsView)
        mainVStack.addArrangedSubview(loginOptionButtonsView)
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(60)
            $0.centerX.equalToSuperview()
        }
        mainVStack.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(70)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        loginFormFieldsView.snp.makeConstraints { $0.horizontalEdges.equalToSuperview() }
        mainLoginButton.snp.makeConstraints { $0.horizontalEdges.equalToSuperview() }
        loginElseDivider.snp.makeConstraints { $0.horizontalEdges.equalToSuperview() }
    }
    
    // MARK: Bindings

}

// MARK: - UIGestureRecognizerDelegate

extension LoginVC: UIGestureRecognizerDelegate {
    /// 제스처가 시작되기 전에 동작 여부를 결정
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool { true }
}

// MARK: - Preview

#Preview { UINavigationController(rootViewController: LoginVC()) }
