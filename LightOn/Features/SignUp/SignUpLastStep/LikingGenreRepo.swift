//
//  LikingGenreRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/3/25.
//

import Combine

import Alamofire

protocol LikingGenreRepo {
    /// 선호 장르 아이디들 전송
    func postLikingGenre(genreItems: [GenreCellItem]) -> AnyPublisher<Void, Never>
}

// MARK: - Default

final class DefaultLikingGenreRepo: LikingGenreRepo {
    func postLikingGenre(genreItems: [GenreCellItem]) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/members/genres",
                method: .post,
                parameters: LikingGenreRequestDTO(from: genreItems),
                encoder: JSONParameterEncoder.default
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                print("선호 장르 전송 완료")
                promise(.success(()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Test

final class TestLikingGenreRepo: LikingGenreRepo {
    func postLikingGenre(genreItems: [GenreCellItem]) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            print("선호 장르 전송 완료(테스트)")
            promise(.success(()))
            
        }
        .eraseToAnyPublisher()
    }
}
