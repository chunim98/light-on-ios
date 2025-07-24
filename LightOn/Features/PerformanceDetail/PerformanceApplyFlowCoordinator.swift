//
//  PerformanceApplyFlowCoordinator.swift
//  LightOn
//
//  Created by 신정욱 on 7/23/25.
//

import UIKit
import Combine

final class PerformanceApplyFlowCoordinator: Coordinator {
    
    // MARK: Properties
    
    weak var parent: (any Coordinator)?     // 부모 없음(?)
    var children: [any Coordinator] = []    // 자식 없음
    let navigation: UINavigationController
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    // MARK: Methods
    
    func start() {} // 사용 안 함
    
    /// 무료공연 신청 모달 표시
    func showFreeApplyModalVC() {
        let vc = FreeApplyModalVC()
        
        // 취소 탭, 화면 닫기
        vc.cancelTapPublisher
            .sink { vc.dismiss(animated: true) }
            .store(in: &cancellables)
        
        // 화면 전환
        vc.sheetPresentationController?.detents = [.custom { _ in 247.6 }]  // 사전 계산 높이
        navigation.present(vc, animated: true)
    }
    
    /// 유로공연 신청 엔트리 모달 표시
    func showPaidEntryModalVC() {
        let vc = PaidEntryModalVC()
        
        // 취소 탭, 화면 닫기
        vc.cancelTapPublisher
            .sink { vc.dismiss(animated: true) }
            .store(in: &cancellables)
        
        // 다음 탭, 관객 수 선택 화면 이동
        vc.acceptTapPublisher
            .sink { [weak self] in
                vc.dismiss(animated: true) { self?.showPaidAudienceCountModalVC() }
            }
            .store(in: &cancellables)
        
        
        // 화면 전환
        vc.sheetPresentationController?.detents = [.custom { _ in 247.6 }]  // 사전 계산 높이
        navigation.present(vc, animated: true)
    }
    
    /// 유료공연 관객 수 선택 모달 표시
    func showPaidAudienceCountModalVC() {
        let vc = PaidAudienceCountModalVC()
        
        // 취소 탭, 화면 닫기
        vc.cancelTapPublisher
            .sink { vc.dismiss(animated: true) }
            .store(in: &cancellables)
        
        // 다음 탭, 지불 정보 확인 및 신청 모달 표시
        vc.acceptTapPublisher
            .sink { [weak self] in
                vc.dismiss(animated: true) { self?.showPaidPaymentInfoModalVC() }
            }
            .store(in: &cancellables)
        
        // 화면 전환
        vc.sheetPresentationController?.detents = [.custom { _ in 281.6 }]  // 사전 계산 높이
        navigation.present(vc, animated: true)
    }
    
    /// 지불 정보 확인 및 신청 모달 표시
    func showPaidPaymentInfoModalVC() {
        let vc = PaidPaymentInfoModalVC()
        
        // 취소 탭, 화면 닫기
        vc.cancelTapPublisher
            .sink { vc.dismiss(animated: true) }
            .store(in: &cancellables)
        
        // 화면 전환
        vc.sheetPresentationController?.detents = [.custom { _ in 386.6 }]  // 사전 계산 높이
        navigation.present(vc, animated: true)
    }
    
    deinit { print("PerformanceApplyFlowCoordinator deinit") }
}
