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
    private let navigationEventPublisher =
    AppCoordinatorBus.shared.navigationEventSubject.eraseToAnyPublisher()
    
    // MARK: Methods
    
    func start() {
        showTabBarController()
        Task {
            try await Task.sleep(nanoseconds: 100000)
            await MainActor.run { showLoginVC() }
        } // temp
    }
    
    private func showTabBarController() {
        let tabBar = TabBarController()
        navigation.pushViewController(tabBar, animated: true)
    }
    
    private func showLoginVC() {
        let coord = LoginSignUpFlowCoordinator(navigation: navigation)
        store(child: coord)
        coord.start()
    }
    
    deinit { print("AppCoordinator deinit") }
}
