//
//  CancelApplicationRepo.swift
//  LightOn
//
//  Created by 신정욱 on 9/3/25.
//

import Combine

import Alamofire

protocol CancelApplicationRepo {
    /// 공연 신청취소 요청
    func requestCancel(id: Int) -> AnyPublisher<Void, Never>
}

// MARK: Default

final class DefaultCancelApplicationRepo: CancelApplicationRepo {
    func requestCancel(id: Int) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/members/performances/\(id)/cancel",
                method: .post
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                print("[CancelApplicationRepo] 공연 신청취소 요청 완료")
                promise(.success(()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
