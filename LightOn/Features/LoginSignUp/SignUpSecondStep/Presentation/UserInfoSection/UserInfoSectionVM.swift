//
//  UserInfoSectionVM.swift
//  LightOn
//
//  Created by 신정욱 on 6/28/25.
//

import Foundation
import Combine

final class UserInfoSectionVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let name: AnyPublisher<String, Never>
        let phoneNumber: AnyPublisher<String, Never>
        
    }
    struct Output {}
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
}
