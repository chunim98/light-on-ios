//
//  PostLikingGenreUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/3/25.
//

import Combine

final class PostLikingGenreUC {
    
    private let repo: LikingGenreRepo
    
    init(repo: LikingGenreRepo) {
        self.repo = repo
    }
    
    /// 선호 장르들 전송
    func execute(
        trigger: AnyPublisher<Void, Never>,
        genreItems: AnyPublisher<[GenreCellItem], Never>
    ) -> AnyPublisher<Void, Never> {
        trigger
            .withLatestFrom(genreItems) { _, items in items }
            .compactMap { [weak self] in self?.repo.postLikingGenre(genreItems: $0) }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
