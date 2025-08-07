//
//  PreferredGenreRepo.swift
//  LightOn
//
//  Created by 신정욱 on 8/7/25.
//

import Combine

import Alamofire

protocol PreferredGenreRepo {
    /// 선호장르 조회
    func getPreferredGenres() -> AnyPublisher<[MyPreferredCellItem], Never>
}

// MARK: Default

final class DefaultPreferredGenreRepo: PreferredGenreRepo {
    func getPreferredGenres() -> AnyPublisher<[MyPreferredCellItem], Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/members/genres",
                method: .get
            )
            .decodeResponse(decodeType: PreferredGenreResDTO.self) {
                print("[PreferredGenreRepo] 선호장르 조회 완료")
                promise(.success($0.genres.map { $0.toDomain() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
