//
//  MyStatsVM.swift
//  LightOn
//
//  Created by 신정욱 on 8/8/25.
//

import Foundation
import Combine

final class MyStatsVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        /// 데이터 로드 트리거
        let loadTrigger: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 내 활동 통계 데이터
        let myStatsInfo: AnyPublisher<MyStatsInfo, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let getMyStatsInfoUC: GetMyStatsInfoUC
    
    // MARK: Initializer
    
    init(repo: any MyStatsInfoRepo) {
        self.getMyStatsInfoUC = .init(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let myStatsInfo = getMyStatsInfoUC.execute(trigger: input.loadTrigger)
        
        return Output(myStatsInfo: myStatsInfo)
    }
}
