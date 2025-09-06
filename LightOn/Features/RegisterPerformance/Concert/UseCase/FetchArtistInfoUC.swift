//
//  FetchArtistInfoUC.swift
//  LightOn
//
//  Created by 신정욱 on 9/6/25.
//

import Combine

final class FetchArtistInfoUC {
    
    private let repo: ArtistInfoRepo
    
    init(repo: ArtistInfoRepo) {
        self.repo = repo
    }
    
    /// 아티스트 정보 조회
    /// - 사용자가 아티스트 상태가 아니면 방출하지 않음
    func execute() -> AnyPublisher<ArtistInfo, Never> {
        SessionManager.shared.isArtist
        ? repo.fetchArtistInfo().share().eraseToAnyPublisher()
        : Empty<ArtistInfo, Never>().eraseToAnyPublisher()
    }
}
