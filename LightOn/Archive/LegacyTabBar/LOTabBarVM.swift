//
//  LOTabBarVM.swift
//  LightOn
//
//  Created by 신정욱 on 5/8/25.
//

import Foundation
import Combine

final class LOTabBarVM {
    
    // MARK: Input & Ouput
    
    struct Input { let selectedIndex: AnyPublisher<Int, Never> }
    struct Output { let selectedIndex: AnyPublisher<Int, Never> }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Event Handling

    func transform(_ input: Input) -> Output {
        let selectedIndexSubject = CurrentValueSubject<Int, Never>(0)

        input.selectedIndex
            .assign(to: \.value, on: selectedIndexSubject)
            .store(in: &cancellables)
        
        return Output(selectedIndex: selectedIndexSubject.eraseToAnyPublisher())
    }
}
