//
//  DetermineApplyButtonModeUC.swift
//  LightOn
//
//  Created by 신정욱 on 9/3/25.
//

import Combine

final class DetermineApplyButtonModeUC {
    /// 공연 상세 화면 하단 액션버튼의 모드를 결정
    ///
    /// - Parameters:
    ///   - perfDetailInfo: 공연 상세 정보 스트림 (공연 종료 여부, 제목, 일정 등 포함)
    ///   - loginState: 로그인 상태 스트림
    ///   - isApplied: 현재 사용자가 해당 공연에 신청했는지 여부 스트림
    ///
    /// - Returns: 버튼 탭 시점에 계산된 액션버튼 모드 스트림
    func execute(
        perfDetailInfo: AnyPublisher<PerformanceDetailInfo, Never>,
        loginState: AnyPublisher<SessionManager.LoginState, Never>,
        isApplied: AnyPublisher<Bool, Never>
    ) -> AnyPublisher<ApplyButtonMode, Never> {
        /// isApplied는 로그인 상태인 경우에만 방출되기 때문에 초기값 제공
        let isApplied = isApplied
            .prepend(false)
            .eraseToAnyPublisher()
        
        // 버튼 모드 결정
        return Publishers
            .CombineLatest3(perfDetailInfo, loginState, isApplied)
            .map { perfDetailInfo, loginState, isApplied -> ApplyButtonMode in
                guard !perfDetailInfo.perfFinished else { return .finished }
                guard loginState == .login else { return .login }
                return isApplied ? .cancel : .apply(isPaid: perfDetailInfo.isPaid)
            }
            .eraseToAnyPublisher()
    }
}
