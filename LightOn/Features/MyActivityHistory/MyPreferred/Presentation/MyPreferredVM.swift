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
        /// 선호 장르 배열
        let preferredGenres: AnyPublisher<[MyPreferredCellItem], Never>
        /// 선호 아티스트 배열
        let preferredArtists: AnyPublisher<[MyPreferredCellItem], Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let getPreferredGenresUC: GetPreferredGenresUC
    private let getPreferredArtistsUC: GetPreferredArtistsUC
    
    // MARK: Initializer
    
    init(
        preferredGenreRepo: any PreferredGenreRepo,
        preferredArtistsRepo: any PreferredArtistsRepo
    ) {
        self.getPreferredGenresUC = .init(repo: preferredGenreRepo)
        self.getPreferredArtistsUC = .init(repo: preferredArtistsRepo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let preferredGenres = getPreferredGenresUC.execute(trigger: input.loadTrigger)
        let preferredArtists = getPreferredArtistsUC.execute(trigger: input.loadTrigger)
        
        return Output(
            preferredGenres: preferredGenres,
            preferredArtists: preferredArtists
        )
    }
}
