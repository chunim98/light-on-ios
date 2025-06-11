//
//  FormatDateHeaderUC.swift
//  LightOn
//
//  Created by 신정욱 on 5/15/25.
//

import UIKit
import Combine

final class FormatDateHeaderUC {
    
    // MARK: Properties
    
    private let currentPageRepository: CurrentPageRepository
    
    // MARK: Initializer
    
    init(currentPageRepository: CurrentPageRepository) {
        self.currentPageRepository = currentPageRepository
    }
    
    // MARK: Methods
    
    func publisher() -> AnyPublisher<String, Never> {
        currentPageRepository.publisher
            .map {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
                formatter.dateFormat = "yyyy년 M월"
                return formatter.string(from: $0)
            }
            .eraseToAnyPublisher()
    }
}
