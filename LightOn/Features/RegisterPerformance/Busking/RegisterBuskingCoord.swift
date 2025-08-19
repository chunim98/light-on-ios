//
//  RegisterBuskingCoord.swift
//  LightOn
//
//  Created by 신정욱 on 8/18/25.
//

import UIKit
import Combine

final class RegisterBuskingCoord: Coordinator {
    
    // MARK: Properties
    
    weak var parent: (any Coordinator)?
    var children: [any Coordinator] = []    // 자식 없음
    let navigation: UINavigationController
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    // MARK: Methods
    
    func start() { showRegisterBuskingVC() }
    
    /// 버스킹 등록 화면 이동
    private func showRegisterBuskingVC() {
        let vc = RegisterBuskingVC()
        
        // 공연등록 완료 또는 뒤로가기 시, 화면 닫기
        Publishers.Merge(vc.registerCompletePublisher, vc.backTapPublisher)
            .sink { [weak self] in self?.navigation.popViewController(animated: true) }
            .store(in: &cancellables)
        
        // 해당 뷰컨 해제 시, 코디네이터도 해제
        vc.deallocatedPublisher
            .sink { [weak self] in self.map { $0.parent?.free(child: $0) } }
            .store(in: &cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: true)
    }
    
    deinit { print("RegisterBuskingCoord deinit") }
}
