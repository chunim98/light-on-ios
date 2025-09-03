//
//  PerformanceDetailFlowCoordinator.swift
//  LightOn
//
//  Created by 신정욱 on 7/23/25.
//

import UIKit
import Combine

final class PerformanceDetailFlowCoordinator: Coordinator {
    
    // MARK: Properties
    
    weak var parent: (any Coordinator)?
    var children: [any Coordinator] = []    // 자식 없음
    let navigation: UINavigationController
    
    private var cancellables = Set<AnyCancellable>()
    private let performanceID: Int
    
    // MARK: Life Cycle
    
    init(
        navigation: UINavigationController,
        performanceID: Int
    ) {
        self.navigation = navigation
        self.performanceID = performanceID
    }
    
    // MARK: Start
    
    func start() { showPerformanceDetailVC() }
    
    // MARK: PerformanceDetailVC
    
    private func showPerformanceDetailVC() {
        let vm = PerformanceDetailDI.shared.makePerformanceDetailVM(
            performanceID: performanceID
        )
        let vc = PerformanceDetailVC(vm: vm)
        
        // 뒤로가기 버튼 탭, 화면 닫기(코디네이터 해제)
        vc.backTapPublisher
            .sink { [weak self] in
                guard let self else { return }
                navigation.popViewController(animated: true)
                parent?.free(child: self)
            }
            .store(in: &cancellables)
        
        // 어떤 이유에서든, 화면이 닫히면 코디네이터 해제
        vc.deallocatedPublisher
            .sink { [weak self] in
                guard let self else { return }
                parent?.free(child: self)
            }
            .store(in: &cancellables)
        
        // 공연 신청 탭, 신청 모달 열기
        vc.applyWithPaidPublisher
            .sink { [weak self] isPaid in
                isPaid
                ? self?.showPaidEntryModalVC()
                : self?.showFreeApplyModalVC()
            }
            .store(in: &cancellables)
        
        // 공연 신청취소 모달 띄우기
        vc.cancelPublisher
            .sink { [weak self] in self?.showCancelApplicationModal() }
            .store(in: &cancellables)
        
        navigation.pushViewController(vc, animated: true)
    }
    
    // MARK: FreeApplyModalVC
    
    /// 무료공연 신청 모달 표시
    private func showFreeApplyModalVC() {
        let vm = PerformanceDetailDI.shared.makeFreeApplyModalVM(
            performanceID: performanceID
        )
        let vc = FreeApplyModalVC(vm: vm)
        
        // 취소 탭, 화면 닫기
        vc.cancelTapPublisher
            .sink { vc.dismiss(animated: true) }
            .store(in: &cancellables)
        
        // 공연 신청 완료, 화면 닫기(코디네이터 해제)
        vc.applicationCompleteEventPublisher
            .sink { [weak self] in
                guard let self else { return }
                vc.dismiss(animated: true) {
                    self.navigation.popViewController(animated: true)
                    self.parent?.free(child: self)
                }
            }
            .store(in: &cancellables)
        
        // 화면 전환
        vc.sheetPresentationController?.detents = [.custom { _ in 247.6 }]  // 사전 계산 높이
        navigation.present(vc, animated: true)
    }
    
    // MARK: PaidEntryModalVC
    
    /// 유로공연 신청 엔트리 모달 표시
    private func showPaidEntryModalVC() {
        let vc = PaidEntryModalVC()
        
        // 취소 탭, 화면 닫기
        vc.cancelTapPublisher
            .sink { vc.dismiss(animated: true) }
            .store(in: &cancellables)
        
        // 다음 탭, 관객 수 선택 화면 이동
        vc.acceptTapPublisher
            .sink { [weak self] in
                vc.dismiss(animated: true) {
                    self?.showAudienceCountPickerModalVC()
                }
            }
            .store(in: &cancellables)
        
        
        // 화면 전환
        vc.sheetPresentationController?.detents = [.custom { _ in 247.6 }]  // 사전 계산 높이
        navigation.present(vc, animated: true)
    }
    
    // MARK: AudienceCountPickerModalVC
    
    /// 유료공연 관객 수 선택 모달 표시
    private func showAudienceCountPickerModalVC() {
        let vc = AudienceCountPickerModalVC()
        
        // 취소 탭, 화면 닫기
        vc.cancelTapPublisher
            .sink { vc.dismiss(animated: true) }
            .store(in: &cancellables)
        
        // 다음 탭, 지불 정보 확인 및 신청 모달 표시
        vc.audienceCountPublisher
            .sink { [weak self] audienceCount in
                vc.dismiss(animated: true) {
                    self?.showPaidApplyModalVC(audienceCount)
                }
            }
            .store(in: &cancellables)
        
        // 화면 전환
        vc.sheetPresentationController?.detents = [.custom { _ in 281.6 }]  // 사전 계산 높이
        navigation.present(vc, animated: true)
    }
    
    // MARK: PaidApplyModalVC
    
    /// 지불 정보 확인 및 신청 모달 표시
    private func showPaidApplyModalVC(_ audienceCount: Int) {
        let vm = PerformanceDetailDI.shared.makePaidApplyModalVM(
            performanceID: performanceID,
            audienceCount: audienceCount
        )
        let vc = PaidApplyModalVC(vm: vm)
        
        // 취소 탭, 화면 닫기
        vc.cancelTapPublisher
            .sink { vc.dismiss(animated: true) }
            .store(in: &cancellables)
        
        // 공연 신청 완료, 화면 닫기(코디네이터 해제)
        vc.applicationCompleteEventPublisher
            .sink { [weak self] in
                guard let self else { return }
                vc.dismiss(animated: true) {
                    self.navigation.popViewController(animated: true)
                    self.parent?.free(child: self)
                }
            }
            .store(in: &cancellables)
        
        // 화면 전환
        vc.sheetPresentationController?.detents = [.custom { _ in 386.6 }]  // 사전 계산 높이
        navigation.present(vc, animated: true)
    }
    
    /// 공연 취소 모달 띄우기
    private func showCancelApplicationModal() {
        let vm = PerformanceDetailDI.shared.makeCancelApplicationModalVM(
            performanceID: performanceID
        )
        let vc = CancelApplicationModalVC(vm: vm)
        
        // 공연신청 취소 완료 시 화면 닫기
        vc.applicationCancelledPublisher
            .sink { [weak self] in self?.navigation.popViewController(animated: true) }
            .store(in: &cancellables)
        
        // 화면 전환
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigation.present(vc, animated: true)
    }
    
    deinit { print("[PerformanceDetailFlowCoordinator] deinit") }
}
