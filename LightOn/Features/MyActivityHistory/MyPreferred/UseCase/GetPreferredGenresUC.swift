//
//  GetPreferredGenresUC.swift
//  LightOn
//
//  Created by 신정욱 on 8/7/25.
//

import Combine

final class GetPreferredGenresUC {
    
    private let repo: PreferredGenreRepo
    
    init(repo: PreferredGenreRepo) {
        self.repo = repo
    }
    
    /// 선호장르 조회
    func execute(
        trigger: AnyPublisher<Void, Never>
    ) -> AnyPublisher<[MyPreferredCellItem], Never> {
        trigger
            .compactMap { [weak self] in self?.repo.getPreferredGenres() }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
