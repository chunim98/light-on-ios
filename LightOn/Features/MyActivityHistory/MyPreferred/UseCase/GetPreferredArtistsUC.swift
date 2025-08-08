//
//  GetPreferredArtistsUC.swift
//  LightOn
//
//  Created by 신정욱 on 8/9/25.
//

import Combine

final class GetPreferredArtistsUC {
    
    private let repo: PreferredArtistsRepo
    
    init(repo: PreferredArtistsRepo) {
        self.repo = repo
    }
    
    /// 선호 아티스트 조회
    func execute(
        trigger: AnyPublisher<Void, Never>
    ) -> AnyPublisher<[MyPreferredCellItem], Never> {
        trigger
            .compactMap { [weak self] in self?.repo.getPreferredArtists() }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
