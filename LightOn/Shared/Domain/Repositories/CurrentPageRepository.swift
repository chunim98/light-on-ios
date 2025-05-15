//
//  CurrentPageRepository.swift
//  LightOn
//
//  Created by 신정욱 on 5/15/25.
//

import UIKit
import Combine

final class CurrentPageRepository {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let currentPageSubject = CurrentValueSubject<Date?, Never>(nil)
    
    // MARK: Methods
    
    func update(from publisher: AnyPublisher<Date, Never>) {
        publisher
            .sink { [weak self] in self?.currentPageSubject.send($0) }
            .store(in: &cancellables)
    }
    
    var publisher: AnyPublisher<Date, Never> {
        currentPageSubject.compactMap { $0 }.eraseToAnyPublisher()
    }
    
    var value: Date? { currentPageSubject.value }
}
