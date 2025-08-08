//
//  PreferredArtistsRepo.swift
//  LightOn
//
//  Created by 신정욱 on 8/9/25.
//

import Combine

import Alamofire

protocol PreferredArtistsRepo {
    /// 선호 아티스트 조회
    func getPreferredArtists() -> AnyPublisher<[MyPreferredCellItem], Never>
}

// MARK: Default

final class DefaultPreferredArtistsRepo: PreferredArtistsRepo {
    func getPreferredArtists() -> AnyPublisher<[MyPreferredCellItem], Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/members/preferred-artist",
                method: .get
            )
            .decodeResponse(decodeType: PreferredArtistsResDTO.self) {
                print("[PreferredArtistsRepo] 선호 아티스트 조회 완료")
                promise(.success($0.artists.map { $0.toDomain() }))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
