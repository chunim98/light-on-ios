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
        /// 최종 인증된 폰번호
        let validPhoneNumber: AnyPublisher<String?, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let requestAuthCodeSMSUC = RequestAuthCodeSMSUC(repo: DefaultAuthCodeRepo())
    private let countDownUC = CountDownUC()
    private let updatePhoneNumberFormStateUC = UpdatePhoneNumberFormStateUC()
    private let verifyPhoneNumberUC = VerifyPhoneNumberUC(repo: DefaultAuthCodeRepo())
    private let getValidPhoneNumberUC = GetValidPhoneNumberUC()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let stateSubject = CurrentValueSubject<PhoneNumberFormState, Never>(.init(
            phoneNumber: "", authCode: "", time: "", isVerified: false, style: .initial
        ))
        
        let smsRequestCompletion = requestAuthCodeSMSUC.execute(
            trigger1: input.requestTap,
            trigger2: input.retryTap,
            state: stateSubject.eraseToAnyPublisher()
        )
        
        let verificationCompletion = verifyPhoneNumberUC.execute(
            trigger: input.confirmTap,
            state: stateSubject.eraseToAnyPublisher()
        )
        
        let countDownSeconds = countDownUC.startCountDown(
            trigger: smsRequestCompletion,
            stopTrigger1: verificationCompletion,
            stopTrigger2: input.phoneNumber
        )
        
        updatePhoneNumberFormStateUC.execute(
            phoneNumber: input.phoneNumber,
            authCode: input.authCode,
            requestTap: input.requestTap,
            countDownSeconds: countDownSeconds,
            verificationCompletion: verificationCompletion,
            state: stateSubject.eraseToAnyPublisher()
        )
        .sink { stateSubject.send($0) }
        .store(in: &cancellables)
        
        let validPhoneNumber = getValidPhoneNumberUC.execute(
            state: stateSubject.eraseToAnyPublisher()
        )
        
        return Output(
            state: stateSubject.eraseToAnyPublisher(),
            validPhoneNumber: validPhoneNumber
        )
    }
}
