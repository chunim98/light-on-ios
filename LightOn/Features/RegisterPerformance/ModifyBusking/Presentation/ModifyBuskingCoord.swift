//
//  ModifyBuskingCoord.swift
//  LightOn
//
//  Created by 신정욱 on 8/29/25.
//

import UIKit
import Combine

final class ModifyBuskingCoord: Coordinator {
    
    // MARK: Properties
    
    weak var parent: (any Coordinator)?
    var children: [any Coordinator] = []    // 자식 없음
    let navigation: UINavigationController
    
    private var cancellables = Set<AnyCancellable>()
    private let performaceID: Int
    
    // MARK: Life Cycle
    
    init(
        performaceID: Int,
        navigation: UINavigationController
    ) {
        self.performaceID = performaceID
        self.navigation = navigation
    }
    
    // MARK: Methods
    
    func start() { showModifyBuskingVC() }
    
    /// 버스킹 등록 화면 이동
    private func showModifyBuskingVC() {
        let vm = RegisterPerformanceDI.shared.makeModifyBuskingVM(id: performaceID)
        let vc = ModifyBuskingVC(vm: vm)
        
        /// 버스킹 수정 및 삭제 완료 또는 뒤로 가기 탭하면 화면 닫기
        Publishers.Merge(vc.editOrDeleteCompletedPublisher, vc.backTapPublisher)
            .sink { [weak self] in self?.navigation.popViewController(animated: true) }
            .store(in: &cancellables)
        
        // 해당 뷰컨 해제 시, 코디네이터도 해제
        vc.deallocatedPublisher
            .sink { [weak self] in self.map { $0.parent?.free(child: $0) } }
            .store(in: &cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: true)
    }
    
    deinit { print("[ModifyBuskingCoord] deinit") }
}
