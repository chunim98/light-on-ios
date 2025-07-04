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
        verificationCompletion: AnyPublisher<Void, Never>,
        state: AnyPublisher<PhoneNumberFormState, Never>
    ) -> AnyPublisher<PhoneNumberFormState, Never> {
        Publishers.MergeMany(
            // 폰번호 작성 시
            phoneNumber.withLatestFrom(state) {
                // 폰번호 문자열 포멧 검사
                let isValidFormat = $0.wholeMatch(of: /^010\d{8}$/) != nil
                
                // 문자열 포멧 검사 여부에 따라 스타일 구성
                let style: PhoneNumberFormStyle
                style = isValidFormat ? .canRequest : .initial
                
                return $1.updated(
                    phoneNumber: $0,    // 폰번호 값 갱신
                    authCode: "",       // 인증 코드 입력 초기화
                    isVerified: false,  // 인증 무효화
                    style: style        // 스타일 반영
                )
            },
            
            // 인증코드 작성 시
            authCode.withLatestFrom(state) { $1.updated(authCode: $0) },
            
            // 문자발송 요청 시
            requestTap.withLatestFrom(state) { $1.updated(style: .inProcess) },
            
            // 타이머 작동 시
            countDownSeconds.withLatestFrom(state) {
                // 타이머 잔여 초, 문자열로 변환
                let timer = String(format: "%02d:%02d", $0/60, $0%60)
                
                // 타이머 소진 여부에 따라 스타일 구성
                let style: PhoneNumberFormStyle
                style = $0 > 0 ? .inProcess : .timeOver
                
                // 타이머 값 갱신, 스타일 반영
                return $1.updated(time: timer, style: style)
            },
            
            // 최종 인증 완료 시
            verificationCompletion.withLatestFrom(state) {
                // 인증 처리, 스타일 반영
                $1.updated(isVerified: true, style: .verified)
            }
        )
        .eraseToAnyPublisher()
    }
}
