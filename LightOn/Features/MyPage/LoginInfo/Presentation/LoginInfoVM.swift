//
//  LoginInfoVM.swift
//  LightOn
//
//  Created by 신정욱 on 8/10/25.
//

import Foundation
import Combine

final class LoginInfoVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let trigger: AnyPublisher<Void, Never>
    }
    struct Output {
        let myInfo: AnyPublisher<MyInfo, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let getMyInfoUC: GetMyInfoUC
    
    // MARK: Initializer
    
    init(repo: any MyInfoRepo) {
        self.getMyInfoUC = .init(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let myInfo = getMyInfoUC.execute(trigger: input.trigger)
         
        return Output(myInfo: myInfo)
    }
}
