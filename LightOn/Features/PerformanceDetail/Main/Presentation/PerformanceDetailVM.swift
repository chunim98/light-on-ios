//
//  PerformanceDetailVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/16/25.
//

import Foundation
import Combine

final class PerformanceDetailVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        /// 하단 액션버튼 탭 이벤트
        let actionTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 공연 상세 정보
        let detailInfo: AnyPublisher<PerformanceDetailInfo, Never>
        /// 하단 액션 버튼 모드
        let buttonMode: AnyPublisher<ApplyButtonMode, Never>
        /// 모드가 포함된 하단 액션버튼 탭 이벤트
        let actionTapWithMode: AnyPublisher<ApplyButtonMode, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let performanceID: Int
    private let performanceDetailRepo: PerformanceDetailRepo
    private let getIsAppliedUC: GetIsAppliedUC
    private let determineButtonModeUC = DetermineApplyButtonModeUC()
    
    // MARK: Initializer
    
    init(
        performanceID: Int,
        performanceDetailRepo: any PerformanceDetailRepo,
        isAppliedRepo: any IsAppliedRepo
    ) {
        self.performanceID = performanceID
        self.performanceDetailRepo = performanceDetailRepo
        self.getIsAppliedUC = .init(repo: isAppliedRepo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 로그인 상태
        let loginState = SessionManager.shared.loginStatePublisher
        
        /// 공연 상세 정보
        let detailInfo = performanceDetailRepo
            .getPerformanceDetail(id: performanceID)
            .share()
            .eraseToAnyPublisher()
        
        /// 이미 신청한 공연인지 여부
        /// - 로그인 상태가 아니면 방출하지 않음
        let isApplied = getIsAppliedUC
            .execute(id: performanceID, loginState: loginState)
            .share()
            .eraseToAnyPublisher()
        
        /// 공연 상세 화면 하단 액션버튼의 모드를 결정
        let buttonMode = determineButtonModeUC.execute(
            perfDetailInfo: detailInfo,
            loginState: loginState,
            isApplied: isApplied
        )
        
        /// 모드가 포함된 하단 액션버튼 탭 이벤트
        let actionTapWithMode = input.actionTap
            .withLatestFrom(buttonMode)
            .eraseToAnyPublisher()
        
        return Output(
            detailInfo: detailInfo,
            buttonMode: buttonMode,
            actionTapWithMode: actionTapWithMode
        )
    }
}
