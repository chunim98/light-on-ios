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
    
    // MARK: Life Cycle
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    // MARK: Methods
    
    func start() { showEntryModalVC() }
    
    private func showEntryModalVC() {
        let vc = RegisterPerformanceEntryModalVC()
        
        
        
        // 화면 전환
        navigation.present(vc, animated: true)
    }
    
    
    deinit { print("RegisterPerformanceFlowCoordinator deinit") }
}
