//
//  LikingGenreRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/3/25.
//

import Combine

protocol LikingGenreRepo {
    /// 선호 장르 아이디들 전송
    func postLikingGenre(genreItems: [GenreCellItem]) -> AnyPublisher<Void, Never>
}

// MARK: - Default

final class DefaultLikingGenreRepo: LikingGenreRepo {
    func postLikingGenre(genreItems: [GenreCellItem]) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            APIClient.shared.requestPost(
                endPoint: "/api/members/genres",
                parameters: LikingGenreRequestDTO(from: genreItems),
                decodeType: EmptyDTO.self
            ) { _ in
                print("선호 장르 전송 완료")
                promise(.success(()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
