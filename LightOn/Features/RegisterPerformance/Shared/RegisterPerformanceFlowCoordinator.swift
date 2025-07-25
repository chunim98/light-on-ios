//
//  RegisterPerformanceFlowCoordinator.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

import UIKit
import Combine

final class RegisterPerformanceFlowCoordinator: Coordinator {
    
    // MARK: Properties
    
    weak var parent: (any Coordinator)?     // 부모 없음
    var children: [any Coordinator] = []    // 자식 없음
    let navigation: UINavigationController
    
    private var cancellables = Set<AnyCancellable>()
    private weak var tabBar: TabBarController?
    
    // MARK: Life Cycle
    
    init(
        navigation: UINavigationController,
        tabBar: TabBarController?
    ) {
        self.navigation = navigation
        self.tabBar = tabBar
    }
    
    // MARK: Methods
    
    func start() { showEntryModalVC() }
    
    private func showEntryModalVC() {
        let vc = RegisterPerformanceEntryModalVC()
        
        // 일반 공연 탭, 화면 이동
        vc.normalTapPublisher
            .sink { [weak self] in
                vc.dismiss(animated: true) { self?.showRegisterPerformanceVC() }
            }
            .store(in: &cancellables)
        
        // 버스킹 탭, 화면 이동
        vc.buskingTapPublisher
            .sink { [weak self] in
                vc.dismiss(animated: true) { self?.showRegisterBuskingVC() }
            }
            .store(in: &cancellables)
        
        // 화면 전환
        navigation.present(vc, animated: true)
    }
    
    private func showRegisterPerformanceVC() {
        let vc = RegisterPerformanceVC()
        
        // 뒤로가기 탭, 화면 닫기
        vc.backTapPublisher
            .sink { [weak self] in self?.navigation.popViewController(animated: true) }
            .store(in: &cancellables)
        
        // 화면 전환
        tabBar?.setTabBarHidden(true)   // 모달 내려간 뒤, 숨기기
        navigation.pushViewController(vc, animated: true)
    }
    
    private func showRegisterBuskingVC() {
        let vc = RegisterBuskingVC()
        
        // 뒤로가기 탭, 화면 닫기
        vc.backTapPublisher
            .sink { [weak self] in self?.navigation.popViewController(animated: true) }
            .store(in: &cancellables)
        
        // 화면 전환
        tabBar?.setTabBarHidden(true)   // 모달 내려간 뒤, 숨기기
        navigation.pushViewController(vc, animated: true)
    }
    
    deinit { print("RegisterPerformanceFlowCoordinator deinit") }
}
