//
//  PhoneNumberFormVM.swift
//  LightOn
//
//  Created by 신정욱 on 6/29/25.
//

import Foundation
import Combine

final class PhoneNumberFormVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let phoneNumber: AnyPublisher<String, Never>
        let authCode: AnyPublisher<String, Never>
        let requestTap: AnyPublisher<Void, Never>
        let retryTap: AnyPublisher<Void, Never>
        let confirmTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 폰번호 인증 폼의 상태
        let state: AnyPublisher<PhoneNumberFormState, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let requestAuthCodeSMSUC = RequestAuthCodeSMSUC(repo: DefaultAuthCodeRepository())
    private let countDownUC = CountDownUC()
    private let updatePhoneNumberFormStateUC = UpdatePhoneNumberFormStateUC()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let stateSubject = CurrentValueSubject<PhoneNumberFormState, Never>(.init(
            phoneNumber: "", authCode: "", time: "",
            authCodeHStackHidden: true,
            requestButtonEnabled: false,
            confirmButtonEnabled: false
        ))
        
        // 이거 완료되면 캡션 보여주면 될 듯?
        let requestSMSCompletionEvent = requestAuthCodeSMSUC.execute(
            trigger1: input.requestTap,
            trigger2: input.retryTap,
            state: stateSubject.eraseToAnyPublisher()
        )
        
        let countDownSeconds = countDownUC.startCountDown(
            trigger1: input.requestTap,
            trigger2: input.retryTap
        )
        
        updatePhoneNumberFormStateUC.execute(
            phoneNumber: input.phoneNumber,
            authCode: input.authCode,
            requestTap: input.requestTap,
            countDownSeconds: countDownSeconds,
            state: stateSubject.eraseToAnyPublisher()
        )
        .sink { stateSubject.send($0) }
        .store(in: &cancellables)
        
        return Output(state: stateSubject.eraseToAnyPublisher())
    }
}
