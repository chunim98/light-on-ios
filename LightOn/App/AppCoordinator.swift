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
    
    // MARK: Methods
    
    func start() { showTabBarController() }
    
    private func showTabBarController() {
        let tabBar = TabBarController()
        navigation.pushViewController(tabBar, animated: true)
    }
    
    deinit { print("AppCoordinator deinit") }
}
