//
//  IsLikedRepo.swift
//  LightOn
//
//  Created by 신정욱 on 9/3/25.
//

import Combine

import Alamofire

protocol IsLikedRepo {
    /// 찜(좋아요) 상태 조회
    func fetch(id: Int) -> AnyPublisher<Bool, Never>
    /// 찜(좋아요) 상태 토글 요청
    func requestToggle(id: Int) -> AnyPublisher<Bool, Never>
}

// MARK: Default

final class DefaultIsLikedRepo: IsLikedRepo {
    func fetch(id: Int) -> AnyPublisher<Bool, Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/members/performances/\(id)/like",
                method: .get
            )
            .decodeResponse(decodeType: IsLikedResDTO.self) {
                print("[IsLikedRepo] 찜(좋아요) 상태 조회 완료")
                promise(.success($0.nowLiked))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func requestToggle(id: Int) -> AnyPublisher<Bool, Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/members/performances/\(id)/like",
                method: .post
            )
            .decodeResponse(decodeType: IsLikedResDTO.self) {
                print("[IsLikedRepo] 찜(좋아요) 상태 토글 완료")
                promise(.success($0.nowLiked))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
