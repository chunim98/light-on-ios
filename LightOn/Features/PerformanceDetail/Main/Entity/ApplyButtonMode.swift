//
//  ApplyButtonMode.swift
//  LightOn
//
//  Created by 신정욱 on 9/2/25.
//

/// 공연 상세 가장 하단에 위치한 액션버튼의 모드
enum ApplyButtonMode {
    /// 탭하면 공연 신청 플로우 시작
    /// - 유료공연 무료공연 여부 포함
    case apply(isPaid: Bool)
    /// 탭하면 공연 취소 플로우 시작
    case cancel
    /// 탭하면 로그인 플로우 시작(로그인 필요한 상태)
    case login
    /// 공연 종료됨(탭 불가)
    case finished
}
