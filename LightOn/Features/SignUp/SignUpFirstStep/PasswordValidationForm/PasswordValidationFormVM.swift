//
//  PasswordValidationFormVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

import Foundation
import Combine

final class PasswordValidationFormVM {
    
    // MARK: Typealias
    
    typealias Format = PasswordValidationFormState.Format
    
    // MARK: Input & Ouput
    
    struct Input {
        let password: AnyPublisher<String, Never>
    }
    struct Output {
        /// 비번 폼 상태
        let state: AnyPublisher<PasswordValidationFormState, Never>
        /// 유효한 비밀번호
        let vaildPassword: AnyPublisher<String?, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let stateSubject = CurrentValueSubject<PasswordValidationFormState, Never>(.init(
            password: "", format: .unknown
        ))
        
        /// 상태 서브젝트 퍼블리셔
        let state = stateSubject.eraseToAnyPublisher()
        
        /// 비밀번호 형식 검사
        let passwordFormat = input.password
            .map { password -> Format in
                guard !password.isEmpty else { return .unknown }
                let regex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=]).{8,}$/
                let isValid = password.wholeMatch(of: regex) != nil
                return isValid ? .valid : .invalid
            }
            .eraseToAnyPublisher()
        
        // 상태 갱신
        Publishers.Merge(
            input.password.withLatestFrom(state) { $1.updated(password: $0) },
            passwordFormat.withLatestFrom(state) { $1.updated(format: $0) }
        )
        .sink { stateSubject.send($0) }
        .store(in: &cancellables)
        
        /// 유효한 비밀번호
        let vaildPassword = state
            .map { $0.format == .valid ? $0.password : nil }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        return Output(state: state, vaildPassword: vaildPassword)
    }
}
