//
//  HomeVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import Foundation
import Combine

final class HomeVM {
    
    // MARK: Input & Ouput
    
    struct Input {}
    struct Output {}
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        
        return Output()
    }
}
