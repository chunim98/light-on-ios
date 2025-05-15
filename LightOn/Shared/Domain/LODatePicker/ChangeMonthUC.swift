//
//  ChangeMonthUC.swift
//  LightOn
//
//  Created by 신정욱 on 5/15/25.
//

import UIKit
import Combine

final class ChangeMonthUC {
    
    // MARK: Properties
    
    private let currentPageRepository: CurrentPageRepository
    
    // MARK: Initializer
    
    init(currentPageRepository: CurrentPageRepository) {
        self.currentPageRepository = currentPageRepository
    }
    
    // MARK: Methods
    
    func publisher(
        previous: AnyPublisher<Void, Never>,
        next: AnyPublisher<Void, Never>
    ) -> AnyPublisher<Date, Never> {
        
        // 이전, 다음 달 계산을 위한 오프셋
        let previousOffset = previous.map { _ in -1 }
        let nextOffset = next.map { _ in 1 }
        
        return Publishers
            .Merge(previousOffset, nextOffset)
            .compactMap { [weak self] offset in
                self?.currentPageRepository.value.flatMap {
                    Calendar.current.date(byAdding: .month, value: offset, to: $0)
                }
            }
            .eraseToAnyPublisher()
    }
}
