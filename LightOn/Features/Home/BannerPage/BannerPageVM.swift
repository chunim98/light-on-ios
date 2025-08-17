//
//  BannerPageVM.swift
//  LightOn
//
//  Created by 신정욱 on 8/17/25.
//

import Foundation
import Combine

final class BannerPageVM {
    
    // MARK: Input & Ouput
    
    struct Input {}
    struct Output {
        /// 배너 공연 배열
        let performances: AnyPublisher<[PerformanceBannerItem], Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let getPerformanceBannerUC: GetPerformanceBannerUC
    
    // MARK: Initializer
    
    init(repo: any PerformanceBannerRepo) {
        self.getPerformanceBannerUC = .init(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 배너 공연 배열
        let performances = getPerformanceBannerUC.execute()
        
        return Output(performances: performances)
    }
}
