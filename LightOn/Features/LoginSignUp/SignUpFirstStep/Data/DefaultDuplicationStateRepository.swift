//
//  DefaultDuplicationStateRepository.swift
//  LightOn
//
//  Created by 신정욱 on 6/2/25.
//

import Combine

import Alamofire

final class DefaultDuplicationStateRepository: DuplicationStateRepository {
    
    func fetchDuplicationState(emailText: String) -> AnyPublisher<DuplicationState, Never> {
        Future { promise in
            AF.request(
                APIConstants.lightOnRootURL + "/api/members/duplicate-check",
                method: .get,
                parameters: ["email": emailText]
            )
            .validate() // 200~299 응답만 성공으로 처리
            .responseDecodable(of: DuplicationStateDTO.self) { response in
                switch response.result {
                    
                case .success(let dto):
                    dto.response.map { promise(.success($0.toDomain())) }
                    
                case .failure(let error):
                    print(#function, error)
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

