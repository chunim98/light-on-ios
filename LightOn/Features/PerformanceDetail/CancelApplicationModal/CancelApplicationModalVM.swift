//
//  CancelApplicationModalVM.swift
//  LightOn
//
//  Created by 신정욱 on 9/3/25.
//

import Foundation
import Combine

final class CancelApplicationModalVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        /// 확인 탭
        let acceptTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 공연신청 취소 완료 이벤트
        let applicationCancelled: AnyPublisher<Void, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let perfomanceID: Int
    private let cancelApplicationRepo: CancelApplicationRepo
    
    // MARK: Initializer
    
    init(
        perfomanceID: Int,
        cancelApplicationRepo: CancelApplicationRepo
    ) {
        self.perfomanceID = perfomanceID
        self.cancelApplicationRepo = cancelApplicationRepo
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 공연신청 취소 완료 이벤트
        let applicationCancelled = input.acceptTap
            .compactMap { [weak self, perfomanceID] in
                self?.cancelApplicationRepo.requestCancel(id: perfomanceID)
            }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
        
        return Output(applicationCancelled: applicationCancelled)
    }
}
