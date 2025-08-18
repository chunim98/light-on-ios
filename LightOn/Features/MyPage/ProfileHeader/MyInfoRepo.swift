//
//  MyInfoRepo.swift
//  LightOn
//
//  Created by 신정욱 on 8/10/25.
//

import Alamofire

import Combine

protocol MyInfoRepo {
    /// 내 정보 조회
    func getMyInfo() -> AnyPublisher<MyInfo, Never>
}

// MARK: Default

final class DefaultMyInfoRepo: MyInfoRepo {
    func getMyInfo() -> AnyPublisher<MyInfo, Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/members/me",
                method: .get
            )
            .decodeResponse(decodeType: MyInfoResDTO.self) {
                print("[\(type(of: self))] 내 정보 조회 완료")
                promise(.success($0.toDomain()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
