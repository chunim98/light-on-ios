//
//  MyRegistrationRequestedVM.swift
//  LightOn
//
//  Created by 신정욱 on 8/9/25.
//

import Foundation
import Combine

final class MyRegistrationRequestedVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        /// 데이터 로드 트리거
        let trigger: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 내 공연 관람 신청 내역 배열
        let requests: AnyPublisher<[MyPerformanceCellItem], Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let getMyRequestedUC: GetMyRequestedUC
    
    // MARK: Initializer
    
    init(repo: any MyRequestedRepo) {
        self.getMyRequestedUC = .init(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let requests = getMyRequestedUC
            .execute(trigger: input.trigger)
            .map {
                guard $0.count > 3 else { return $0 }
                return Array($0[..<3]) // 3개 제한
            }
            .eraseToAnyPublisher()
        
        return Output(requests: requests)
    }
}

