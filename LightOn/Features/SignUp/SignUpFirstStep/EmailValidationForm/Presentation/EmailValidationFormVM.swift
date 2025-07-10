//
//  EmailValidationFormVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

import Foundation
import Combine

final class EmailValidationFormVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let email: AnyPublisher<String, Never>
        let checkDuplicationTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 뷰 상태
        let state: AnyPublisher<EmailValidationFormState, Never>
        /// 유효한 이메일
        let validEmail: AnyPublisher<String?, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let updateFormStateUC = UpdateEmailValidationFormStateUC()
    private let checkEmailDuplicationUC: CheckEmailDuplicationUC
    
    init(repo: CheckEmailDuplicationRepo) {
        self.checkEmailDuplicationUC = CheckEmailDuplicationUC(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let stateSubject = CurrentValueSubject<EmailValidationFormState, Never>(.init(
            email: "", duplication: .unknown, format: .unknown
        ))
        
        /// 이메일 형식 검사
        let emailFormat = input.email
            .map { email -> EmailValidationFormState.Format in
                guard !email.isEmpty else { return .unknown }
                let regex = /^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$/
                let isValid = email.wholeMatch(of: regex) != nil
                return isValid ? .valid : .invalid
            }
            .eraseToAnyPublisher()
        
        let duplication = checkEmailDuplicationUC.execute(
            trigger: input.checkDuplicationTap,
            state: stateSubject.eraseToAnyPublisher()
        )
        
        updateFormStateUC.execute(
            email: input.email,
            duplication: duplication,
            emailFormat: emailFormat,
            state: stateSubject.eraseToAnyPublisher()
        )
        .sink { stateSubject.send($0) }
        .store(in: &cancellables)
        
        // 유효한 이메일
        let validEmail = stateSubject
            .map {
                $0.duplication == .notDuplicated &&
                $0.format == .valid ?
                $0.email : nil
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        return Output(
            state: stateSubject.eraseToAnyPublisher(),
            validEmail: validEmail
        )
    }
}
