//
//  MyPreferredVM.swift
//  LightOn
//
//  Created by 신정욱 on 8/7/25.
//

import Foundation
import Combine

final class MyPreferredVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        /// 컬렉션 뷰 데이터 로드 트리거
        let loadTrigger: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 선호 장르 배열들
        let preferredGenres: AnyPublisher<[MyPreferredCellItem], Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let getPreferredGenresUC: GetPreferredGenresUC
    
    // MARK: Initializer
    
    init(repo: any PreferredGenreRepo) {
        self.getPreferredGenresUC = .init(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let preferredGenres = getPreferredGenresUC.execute(
            trigger: input.loadTrigger
        )
        
        return Output(preferredGenres: preferredGenres)
    }
}
