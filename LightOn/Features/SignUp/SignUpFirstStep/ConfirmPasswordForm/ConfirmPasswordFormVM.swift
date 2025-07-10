//
//  ConfirmPasswordFormVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

import Foundation
import Combine

final class ConfirmPasswordFormVM {
    
    // MARK: Typealias
    
    typealias Matching = ConfirmPasswordFormState.Matching
    
    // MARK: Input & Ouput
    
    struct Input {
        let confirmPassword: AnyPublisher<String, Never>
        let originPassword: AnyPublisher<String?, Never>
    }
    struct Output {
        // 비번 확인 폼 상태
        let state: AnyPublisher<ConfirmPasswordFormState, Never>
        // 유효한 확인 비번
        let vaildConfirmPassword: AnyPublisher<String?, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let stateSubject = CurrentValueSubject<ConfirmPasswordFormState, Never>(.init(
            confirmPassword: "", matchingState: .unknown
        ))
        
        /// 상태 서브젝트 퍼블리셔
        let state = stateSubject.eraseToAnyPublisher()
        
        /// 확인 비밀번호 일치 검사
        let matchingState = Publishers
            .CombineLatest(input.confirmPassword, input.originPassword)
            .map { confirm, origin -> Matching in
                guard !confirm.isEmpty else { return .unknown }
                guard let origin else { return .originBadFormat }
                return confirm == origin ? .matched : .notMatched
            }
            .eraseToAnyPublisher()
        
        // 상태 갱신
        Publishers.Merge(
            input.confirmPassword.withLatestFrom(state) {
                $1.updated(confirmPassword: .some($0))
            },
            matchingState.withLatestFrom(state) {
                $1.updated(matchingState: $0)
            }
        )
        .sink { stateSubject.send($0) }
        .store(in: &cancellables)
        
        /// 유효한 비밀번호
        let vaildConfirmPassword = state
            .map { $0.matchingState == .matched ? $0.confirmPassword : nil }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        return Output(state: state, vaildConfirmPassword: vaildConfirmPassword)
    }
}
