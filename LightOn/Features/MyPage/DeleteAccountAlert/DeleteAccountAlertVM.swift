//
//  DeleteAccountAlertVM.swift
//  LightOn
//
//  Created by 신정욱 on 8/19/25.
//

import Foundation
import Combine

final class DeleteAccountAlertVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        /// 회원탈퇴 요청 트리거
        let trigger: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 회원탈퇴 완료 이벤트
        let accountDeleted: AnyPublisher<Void, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let deleteAccountUC: DeleteAccountUC
    
    init(repo: DeleteAccountRepo) {
        self.deleteAccountUC = .init(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 회원탈퇴 완료 이벤트
        let accountDeleted = deleteAccountUC.execute(trigger: input.trigger)
        
        return Output(accountDeleted: accountDeleted)
    }
}
