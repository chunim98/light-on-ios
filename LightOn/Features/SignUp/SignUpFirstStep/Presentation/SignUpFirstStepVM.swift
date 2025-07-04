//
//  SignUpFirstStepVM.swift
//  LightOn
//
//  Created by 신정욱 on 5/31/25.
//

import Foundation
import Combine

final class SignUpFirstStepVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let emailText: AnyPublisher<String, Never>
        let pwText: AnyPublisher<String, Never>
        let confirmText: AnyPublisher<String, Never>
        let duplicationTap: AnyPublisher<Void, Never>
        let nextButtonTap: AnyPublisher<Void, Never>
    }
    struct Output {
        let isNextButtonEnabled: AnyPublisher<Bool, Never>
        let isDuplicationButtonEnabled: AnyPublisher<Bool, Never>
        let emailCaption: AnyPublisher<SignUpTextForm.CaptionConfiguration?, Never>
        let pwCaption: AnyPublisher<SignUpTextForm.CaptionConfiguration?, Never>
        let confirmCaption: AnyPublisher<SignUpTextForm.CaptionConfiguration?, Never>
        /// 임시 회원 번호
        let tempUserID: AnyPublisher<Int, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: UseCases
    
    private let makeRootStateUC = MakeRootStateUC()
    private let emailVerificationUC: EmailVerificationUC
    private let pwVerificationUC = PWVerificationUC()
    private let makeCaptionUC = MakeCaptionUC()
    private let buttonEnabledUC = ButtonEnabledUC()
    private let requestPresignUpUC: RequestPresignUpUC
    
    // MARK: Initializer
    
    init(
        duplicationStateRepo: DuplicationStateRepo,
        presignUpRepo: PresignUpRepo
    ) {
        self.emailVerificationUC = EmailVerificationUC(repository: duplicationStateRepo)
        self.requestPresignUpUC = RequestPresignUpUC(repo: presignUpRepo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        // 이메일, 비번 상태 서브젝트
        let emailStateSubject = CurrentValueSubject<EmailState, Never>(.init())
        let pwStateSubject = CurrentValueSubject<PWState, Never>(.init())
        
        // 이메일, 비번 서브젝트의 퍼블리셔
        let emailState = emailStateSubject.eraseToAnyPublisher()
        let pwState = pwStateSubject.eraseToAnyPublisher()
        
        // 이메일, 비번 검증 파이프라인의 시작 지점
        let rootEmailState = makeRootStateUC.makeEmailState(input.emailText)
        let rootPWState = makeRootStateUC.makePWState(input.pwText, input.confirmText)
        
        // 이메일 검증 1단계: 이메일 형식 검사
        emailVerificationUC
            .checkFormat(rootEmailState)
            .sink { emailStateSubject.send($0) }
            .store(in: &cancellables)
        
        // 이메일 검증 2단계: 이메일 중복 검사
        emailVerificationUC
            .checkDuplication(input.duplicationTap, emailState)
            .sink { emailStateSubject.send($0) }
            .store(in: &cancellables)
        
        // 비밀번호 검증
        pwVerificationUC
            .checkFormat(rootPWState)
            .sink { pwStateSubject.send($0) }
            .store(in: &cancellables)
        
        // 이메일, 비번 상태로 캡션 만들기
        let emailCaption = makeCaptionUC.makeEmailCaption(emailState)
        let pwCaption = makeCaptionUC.makePWCaption(pwState)
        let confirmCaption = makeCaptionUC.makeConfirmCaption(pwState)
        
        // 중복버튼 활성화 여부
        let isDuplicationButtonEnabled = buttonEnabledUC
            .getDuplicationButtonEnabled(emailState, input.duplicationTap)
        
        // 다음버튼 활성화 여부
        let isNextButtonEnabled = buttonEnabledUC
            .getNextButtonEnabled(emailState, pwState)
        
        // 임시 회원번호
        let tempUserID = requestPresignUpUC.execute(
            trigger: input.nextButtonTap,
            email: emailState,
            pw: pwState
        )
        
        return Output(
            isNextButtonEnabled:        isNextButtonEnabled,
            isDuplicationButtonEnabled: isDuplicationButtonEnabled,
            emailCaption:               emailCaption,
            pwCaption:                  pwCaption,
            confirmCaption:             confirmCaption,
            tempUserID:                 tempUserID
        )
    }
}
