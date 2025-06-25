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
    
    private let repo: CurrentPageRepo
    
    // MARK: Initializer
    
    init(repo: CurrentPageRepo) {
        self.repo = repo
    }
    
    // MARK: Methods
    
    func publisher() -> AnyPublisher<String, Never> {
        repo.publisher
            .map {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
                formatter.dateFormat = "yyyy년 M월"
                return formatter.string(from: $0)
            }
            .eraseToAnyPublisher()
    }
}
