//
//  AppCoordinator.swift
//  LightOn
//
//  Created by 신정욱 on 6/28/25.
//

import UIKit
import Combine

final class AppCoordinator: Coordinator {
    
    // MARK: Properties
    
    weak var parent: (any Coordinator)? // 부모 없음(?)
    var children: [any Coordinator] = [] // 자식 없음
    let navigation = UINavigationController()
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 화면전환 이벤트 퍼블리셔
    private let navigationEvent =
    AppCoordinatorBus.shared.navigationEventSubject.eraseToAnyPublisher()
    
    // MARK: Methods
    
    func start() {
        showTabBarController()
        
        // 외부에서 전달받은 화면이동 요청 바인딩
        navigationEvent
            .sink { [weak self] event in
                switch event {
                case .login:
                    self?.showLoginVC()
                    
                case .signUp:
                    self?.startSignUpFlow()
                    
                case .performanceDetail(id: let id):
                    self?.startPerformanceDetailFlow(id)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showTabBarController() {
        let tabBar = TabBarController()
        navigation.pushViewController(tabBar, animated: true)
    }
    
    private func showLoginVC() {
        let vc = LoginVC()
        
        // 닫기 버튼, 로그인 완료, 화면 닫기
        Publishers.Merge(
            vc.closeTapPublisher,
            vc.loginCompletePublisher
        )
        .sink { vc.dismiss(animated: true) }
        .store(in: &cancellables)
        
        // 모달 풀 스크린으로 화면 이동
        let flowNav = UINavigationController(rootViewController: vc)
        flowNav.modalPresentationStyle = .fullScreen
        navigation.present(flowNav, animated: true)
    }
    
    private func startSignUpFlow() {
        // 빈 모달 만들고 그 안에서 플로우 시작
        let flowNav = UINavigationController()
        flowNav.modalPresentationStyle = .fullScreen
        navigation.present(flowNav, animated: true)
        
        let coord = SignUpFlowCoordinator(navigation: flowNav, isInModal: true)
        store(child: coord)
        coord.start()
    }
    
    /// 공연 상세 코디네이터 시작
    private func startPerformanceDetailFlow(_ performanceID: Int) {
        let coord = PerformanceDetailFlowCoordinator(
            navigation: navigation,
            performanceID: performanceID
        )
        store(child: coord)
        coord.start()
    }
}
