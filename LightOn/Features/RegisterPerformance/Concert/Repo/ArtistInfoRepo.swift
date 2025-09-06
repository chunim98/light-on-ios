//
//  ArtistInfoRepo.swift
//  LightOn
//
//  Created by 신정욱 on 9/6/25.
//

import Combine

import Alamofire

protocol ArtistInfoRepo {
    /// 아티스트 정보 조회
    func fetchArtistInfo() -> AnyPublisher<ArtistInfo, Never>
}

// MARK: Default

final class DefaultArtistInfoRepo: ArtistInfoRepo {
    func fetchArtistInfo() -> AnyPublisher<ArtistInfo, Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/artists/me/info",
                method: .get
            )
            .decodeResponse(decodeType: ArtistInfoResDTO.self) {
                print("[ArtistInfoRepo] 아티스트 정보 조회 완료")
                promise(.success($0.toDomain()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
