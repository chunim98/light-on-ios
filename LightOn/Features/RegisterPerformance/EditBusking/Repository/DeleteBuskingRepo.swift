//
//  DeleteBuskingRepo.swift
//  LightOn
//
//  Created by 신정욱 on 8/29/25.
//

import Foundation
import Combine

import Alamofire

protocol DeleteBuskingRepo {
    /// 버스킹 취소 요청
    func requestDeleteBusking(id: Int) -> AnyPublisher<Void, Never>
}

// MARK: Default

final class DefaultDeleteBuskingRepo: DeleteBuskingRepo {
    func requestDeleteBusking(id: Int) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            /// 아티스트 상태면 아티스트 버스킹으로 취소
            let endpoint = SessionManager.shared.isArtist
            ? "/api/artists/performances/buskings/\(id)"
            : "/api/members/performances/buskings/\(id)"
            
            APIClient.withAuth.request(
                BaseURL + endpoint,
                method: .delete
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                print("[DeleteBuskingRepo] 버스킹 취소 요청 완료")
                promise(.success(()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
