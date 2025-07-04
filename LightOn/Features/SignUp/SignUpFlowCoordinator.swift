//
//  SignUpFlowCoordinator.swift
//  LightOn
//
//  Created by 신정욱 on 6/28/25.
//

import UIKit
import Combine

import CombineCocoa

final class SignUpFlowCoordinator: Coordinator {
    
    // MARK: Properties
    
    weak var parent: (any Coordinator)? // 부모 없음(?)
    var children: [any Coordinator] = [] // 자식 없음
    let navigation: UINavigationController
    
    private var cancellables = Set<AnyCancellable>()
    private let isInModal: Bool
    
    // MARK: Initializer
    
    init(navigation: UINavigationController, isInModal: Bool) {
        self.isInModal = isInModal
        self.navigation = navigation
    }
    
    // MARK: Methods
    
    func start() { showSignUpFirstStepVC() }
    
    private func showSignUpFirstStepVC() {
        let vc = SignUpFirstStepVC(isInModal: isInModal)
        
        // 뒤로가기 버튼, 화면 닫기 (모달이 아닐 경우)
        vc.backBarButton.tapPublisher
            .sink { [weak self] _ in self?.navigation.popViewController(animated: true) }
            .store(in: &cancellables)
        
        // 닫기 버튼, 화면 닫기 (모달인 경우)
        vc.closeTapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                navigation.dismiss(animated: true) {
                    self.parent?.free(child: self)
                }
            }
            .store(in: &cancellables)
        
        // 임시 회원번호, 회원가입 2단계 이동
        vc.tempUserIDPublisher
            .sink { [weak self] in self?.showSignUpSecondStepVC(tempUserID: $0) }
            .store(in: &cancellables)
        
        // 화면 이동
        navigation.pushViewController(vc, animated: true)
    }
    
    private func showSignUpSecondStepVC(tempUserID: Int) {
        let vm = LoginSignUpDI.shared.makeSignUpSecondStepVM(tempUserID: tempUserID)
        let vc = SignUpSecondStepVC(vm: vm)
        
        // 뒤로가기 버튼, 화면 닫기
        vc.backBarButton.tapPublisher
            .sink { [weak self] _ in self?.navigation.popViewController(animated: true) }
            .store(in: &cancellables)
        
        // 회원가입 완료, 장르선택 화면 이동
        vc.signUpCompletionPublisher
            .sink { [weak self] in self?.showSelectLikingVC() }
            .store(in: &cancellables)
        
        // 화면 이동
        navigation.pushViewController(vc, animated: true)
    }
    
    private func showSelectLikingVC() {
        let vc = SelectLikingVC()
        
        // 선호 장르 선택 완료, 건너뛰기, 완료 화면 이동
        Publishers.Merge(
            vc.postCompletionPublisher,
            vc.skipTapPublisher
        )
        .sink { [weak self] in self?.showSignUpCompleteVC() }
        .store(in: &cancellables)
        
        // 화면 이동
        navigation.pushViewController(vc, animated: true)
    }
    
    private func showSignUpCompleteVC() {
        let vc = SignUpCompleteVC()
        
        // 다음 버튼, 화면 닫기
        vc.nextTapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                navigation.dismiss(animated: true) {
                    self.parent?.free(child: self)
                }
            }
            .store(in: &cancellables)
        
        // 화면 이동
        navigation.pushViewController(vc, animated: true)
    }
    
    deinit { print("SignUpFlowCoordinator deinit") }
}
