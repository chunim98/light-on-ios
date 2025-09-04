//
//  IsArtistRepo.swift
//  LightOn
//
//  Created by 신정욱 on 9/4/25.
//

import Combine

import Alamofire

protocol IsArtistRepo {
    /// 사용자 아티스트 상태 여부 조회
    func fetchIsArtist() -> AnyPublisher<Bool, Never>
}

// MARK: Default

final class DefaultIsArtistRepo: IsArtistRepo {
    func fetchIsArtist() -> AnyPublisher<Bool, Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/artists/me",
                method: .get
            )
            .decodeResponse(decodeType: IsArtistResDTO.self) {
                print("[IsArtistRepo] 사용자 아티스트 상태 여부 조회 완료")
                promise(.success($0.isArtist))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
