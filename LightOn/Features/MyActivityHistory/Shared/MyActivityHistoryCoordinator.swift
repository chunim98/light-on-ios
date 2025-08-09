//
//  MyActivityHistoryCoordinator.swift
//  LightOn
//
//  Created by 신정욱 on 8/9/25.
//

import UIKit
import Combine

final class MyActivityHistoryCoordinator: Coordinator {
    
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
    
    func start() { showMyActivityHistory() }
    
    private func showMyActivityHistory() {
        let vc = MyActivityHistoryVC()
        
        /// 뒤로 가기 버튼 탭, 화면 닫기
        vc.backTapPublisher
            .sink { [weak self] in
                self?.navigation.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: true)
    }
    
    deinit { print("\(type(of: self)) deinit") }
}
