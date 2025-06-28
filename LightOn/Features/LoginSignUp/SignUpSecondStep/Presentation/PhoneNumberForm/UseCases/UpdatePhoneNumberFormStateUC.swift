//
//  UpdatePhoneNumberFormStateUC.swift
//  LightOn
//
//  Created by 신정욱 on 6/29/25.
//

import Combine

final class UpdatePhoneNumberFormStateUC {
    /// 폰 번호 인증 폼 상태 업데이트
    func execute(
        phoneNumber: AnyPublisher<String, Never>,
        authCode: AnyPublisher<String, Never>,
        requestTap: AnyPublisher<Void, Never>,
        countDownSeconds: AnyPublisher<Int, Never>,
        state: AnyPublisher<PhoneNumberFormState, Never>
    ) -> AnyPublisher<PhoneNumberFormState, Never> {
        Publishers.MergeMany(
            // 현재 값 업데이트
            phoneNumber.withLatestFrom(state) { $1.updated(phoneNumber: $0) },
            // 폰번호 문자열 포멧 검사
            phoneNumber.withLatestFrom(state) {
                let regex = /^010\d{8}$/
                let isValid = $0.wholeMatch(of: regex) != nil
                return $1.updated(requestButtonEnabled: isValid)
            },
            
            // 현재 값 업데이트
            authCode.withLatestFrom(state) { $1.updated(authCode: $0) },
            
            // 문자발송 요청시, 인증코드 필드 표시
            requestTap.withLatestFrom(state) { $1.updated(authCodeHStackHidden: false) },
            requestTap.withLatestFrom(state) { $1.updated(requestButtonEnabled: false) },
            
            // 타이머 잔여 초, 문자열로 변환
            countDownSeconds.withLatestFrom(state) {
                let formatted = String(format: "%02d:%02d", $0/60, $0%60)
                return $1.updated(time: formatted)
            },
            // 타이머 소진 시, 인증버튼 비활성화(재시도만 가능)
            countDownSeconds.withLatestFrom(state) { $1.updated(confirmButtonEnabled: $0 > 0) }
        )
        .eraseToAnyPublisher()
    }
}
