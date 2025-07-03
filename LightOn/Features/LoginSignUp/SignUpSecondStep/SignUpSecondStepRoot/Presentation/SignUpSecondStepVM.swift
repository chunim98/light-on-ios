//
//  SignUpSecondStepVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/3/25.
//

import Foundation
import Combine

final class SignUpSecondStepVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let name: AnyPublisher<String?, Never>
        let phone: AnyPublisher<String?, Never>
        let regionCode: AnyPublisher<Int?, Never>
        let termsAgreed: AnyPublisher<Bool, Never>
        let smsAgreed: AnyPublisher<Bool, Never>
        let pushAgreed: AnyPublisher<Bool, Never>
        let emailAgreed: AnyPublisher<Bool, Never>
        let nextButtonTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 다음 버튼 활성화 여부
        let nextButtonEnabled: AnyPublisher<Bool, Never>
        /// 회원가입 완료 이벤트
        let signUpCompletion: AnyPublisher<Void, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let tempUserID: Int
    
    private let updateMemberInfoUC = UpdateMemberInfoUC()
    private let isMemberInfoValidUC = IsMemberInfoValidUC()
    private let requestSignUpUC: RequestSignUpUC
    
    init(
        tempUserID: Int,
        signUpRepo: SignUpRepo
    ) {
        self.tempUserID = tempUserID
        self.requestSignUpUC = RequestSignUpUC(repo: signUpRepo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let memberInfoSubject = CurrentValueSubject<MemberInfo, Never>(.init(
            tempMemberID: tempUserID, name: nil, phone: nil, regionCode: nil,
            termsAgreed: false, smsAgreed: false, pushAgreed: false, emailAgreed: false
        ))
        
        updateMemberInfoUC.execute(
            name: input.name,
            phone: input.phone,
            regionCode: input.regionCode,
            termsAgreed: input.termsAgreed,
            smsAgreed: input.smsAgreed,
            pushAgreed: input.pushAgreed,
            emailAgreed: input.emailAgreed,
            memberInfo: memberInfoSubject.eraseToAnyPublisher()
        )
        .sink { memberInfoSubject.send($0) }
        .store(in: &cancellables)
        
        let nextButtonEnabled = isMemberInfoValidUC.execute(
            memberInfo: memberInfoSubject.eraseToAnyPublisher()
        )
        
        let userToken = requestSignUpUC.execute(
            trigger: input.nextButtonTap,
            memberInfo: memberInfoSubject.eraseToAnyPublisher()
        )
        
        // 로그인 성공 시, 발급받은 토큰 저장
        userToken.sink {
            TokenKeychain.shared.save(.access, token: $0.accessToken)
            TokenKeychain.shared.save(.refresh, token: $0.refreshToken)
        }
        .store(in: &cancellables)
        
        let signUpCompletion = userToken.map { _ in }
            .eraseToAnyPublisher()
        
        return Output(
            nextButtonEnabled: nextButtonEnabled,
            signUpCompletion: signUpCompletion
        )
    }
}
