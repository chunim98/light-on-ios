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
        let emailText: AnyPublisher<String?, Never>
        let pwText: AnyPublisher<String?, Never>
        let confirmText: AnyPublisher<String?, Never>
        let nextButtonTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 다음버튼 활성화 여부
        let isNextButtonEnabled: AnyPublisher<Bool, Never>
        /// 임시 회원 번호
        let tempUserID: AnyPublisher<Int, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: UseCases
    
    private let requestPresignUpUC: RequestPresignUpUC
    
    // MARK: Initializer
    
    init(presignUpRepo: PresignUpRepo) {
        self.requestPresignUpUC = RequestPresignUpUC(repo: presignUpRepo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let stateSubject = CurrentValueSubject<SignUpFirstStepState, Never>(.init(
            email: nil, password: nil, confirmPassword: nil
        ))
        
        /// 서브젝트 퍼블리셔
        let state = stateSubject.eraseToAnyPublisher()
        
        // 상태 갱신
        Publishers.Merge3(
            input.emailText.withLatestFrom(state)   { $1.updated(email: .some($0)) },
            input.pwText.withLatestFrom(state)      { $1.updated(password: .some($0)) },
            input.confirmText.withLatestFrom(state) { $1.updated(confirmPassword: .some($0)) }
        )
        .sink { stateSubject.send($0) }
        .store(in: &cancellables)
        
        /// 다음버튼 활성화 여부
        let isNextButtonEnabled = state.map {
            $0.confirmPassword != nil &&
            $0.password != nil &&
            $0.email != nil
        }.eraseToAnyPublisher()
        
        /// 임시 회원번호
        let tempUserID = requestPresignUpUC.execute(
            trigger: input.nextButtonTap,
            state: state
        )
        
        return Output(
            isNextButtonEnabled: isNextButtonEnabled,
            tempUserID: tempUserID
        )
    }
}
