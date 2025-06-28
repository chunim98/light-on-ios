//
//  LoginSignUpFlowCoordinator.swift
//  LightOn
//
//  Created by 신정욱 on 6/28/25.
//

import UIKit
import Combine

import CombineCocoa

final class LoginSignUpFlowCoordinator: Coordinator {
    
    // MARK: Properties
    
    weak var parent: (any Coordinator)? // 부모 없음(?)
    var children: [any Coordinator] = [] // 자식 없음
    let navigation: UINavigationController
    
    private var flowNav: UINavigationController?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Initializer
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    // MARK: Methods
    
    func start() { showLoginVC() }
    
    private func showLoginVC() {
        let vc = LoginVC()
        
        // 회원가입 버튼, 회원가입 1단계 이동
        vc.signUpTapPublisher
            .sink { [weak self] _ in self?.showSignUpFirstStepVC() }
            .store(in: &cancellables)
        
        // 뒤로가기 버튼, 화면 닫기
        vc.backBarButton.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                navigation.dismiss(animated: true) {
                    self.parent?.free(child: self)
                }
            }
            .store(in: &cancellables)

        // 모달 풀 스크린으로 화면 이동
        flowNav = UINavigationController(rootViewController: vc)
        flowNav?.modalPresentationStyle = .fullScreen
        if let flowNav { navigation.present(flowNav, animated: true) }
    }
    
    private func showSignUpFirstStepVC() {
        let vc = SignUpFirstStepVC()
        
        // 뒤로가기 버튼, 화면 닫기
        vc.backBarButton.tapPublisher
            .sink { [weak self] _ in self?.flowNav?.popViewController(animated: true) }
            .store(in: &cancellables)
        
        // 다음 버튼 탭, 회원가입 2단계 이동
        vc.nextTapPublisher
            .sink { [weak self] _ in self?.showSignUpSecondSetpVC() }
            .store(in: &cancellables)
        
        // 화면 이동
        flowNav?.pushViewController(vc, animated: true)
    }
    
    private func showSignUpSecondSetpVC() {
        let vc = SignUpSecondStepVC()
        
        // 뒤로가기 버튼, 화면 닫기
        vc.backBarButton.tapPublisher
            .sink { [weak self] _ in self?.flowNav?.popViewController(animated: true) }
            .store(in: &cancellables)
        
        // 화면 이동
        flowNav?.pushViewController(vc, animated: true)
    }
    
    deinit { print("LoginSignUpFlowCoordinator deinit") }
}
