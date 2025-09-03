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
        
        // 뒤로 가기 버튼 탭, 화면 닫기
        vc.backTapPublisher
            .sink { [weak self] in
                self?.navigation.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        // 공연 등록 내역 상세로 전환
        vc.registaionDetailTapPublisher
            .sink { [weak self] in self?.showMyRegistrationRequestedFull() }
            .store(in: &cancellables)
        
        // 관람 신청 내역 상세로 전환
        vc.applicationDetailTapPublisher
            .sink { [weak self] in self?.showMyApplicationRequestedFull() }
            .store(in: &cancellables)
        
        // 등록한 공연 셀 선택 시, 수정화면으로 이동
        // (추후, 버스킹인지, 일반공연인지 확인하는 로직 필요할듯)
        vc.registeredIDPublisher
            .sink { AppCoordinatorBus.shared.navigate(to: .editBusking(id: $0)) }
            .store(in: &cancellables)
        
        // 신청한 공연 셀 선택 시, 공연 상세 화면으로 이동
        // (일단 버스킹만 지원하니까 나중에는 셀 내부 버튼 눌러야 이동하게끔 수정해야함)
        vc.appliedIDPublisher
            .sink { AppCoordinatorBus.shared.navigate(to: .performanceDetail(id: $0)) }
            .store(in: &cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: true)
    }
    
    private func showMyRegistrationRequestedFull() {
        let vc = MyRegistrationRequestedFullVC()
        
        /// 뒤로 가기 버튼 탭, 화면 닫기
        vc.backTapPublisher
            .sink { [weak self] in self?.navigation.popViewController(animated: true) }
            .store(in: &cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: true)
    }
    
    private func showMyApplicationRequestedFull() {
        let vc = MyApplicationRequestedFullVC()
        
        /// 뒤로 가기 버튼 탭, 화면 닫기
        vc.backTapPublisher
            .sink { [weak self] in self?.navigation.popViewController(animated: true) }
            .store(in: &cancellables)
        
        // 화면 전환
        navigation.pushViewController(vc, animated: true)
    }
    
    deinit { print("\(type(of: self)) deinit") }
}
