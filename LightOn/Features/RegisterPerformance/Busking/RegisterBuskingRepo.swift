//
//  RegisterBuskingRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import Foundation
import Combine

import Alamofire

protocol RegisterBuskingRepo {
    /// 버스킹 등록 요청
    func requestRegisterBusking(
        info: RegisterBuskingInfo,
        posterData: Data,
        documentData: Data
    ) -> AnyPublisher<Void, Never>
}

// MARK: - Default

final class DefaultRegisterBuskingRepo: RegisterBuskingRepo {
    func requestRegisterBusking(
        info: RegisterBuskingInfo,
        posterData: Data,
        documentData: Data
    ) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            guard let jsonData = try? JSONEncoder().encode(
                RegisterBuskingReqDTO(from: info)
            ) else { return }
            
            // 서버에 전송 요청
            APIClient.withAuth.upload(
                multipartFormData: { multipartFormData in
                    // json 텍스트로 만들어서 전송
                    multipartFormData.append(
                        jsonData,
                        withName: "data",
                        mimeType: "application/json"
                    )
                    // 증빙자료 전송
                    multipartFormData.append(
                        documentData,
                        withName: "proof",
                        mimeType: "image/png"
                    )
                    // 포스터 이미지 전송
                    multipartFormData.append(
                        posterData,
                        withName: "posterImage",
                        mimeType: "image/png"
                    )
                },
                to: BaseURL + "/api/members/performances/buskings"
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                print("버스킹 등록 요청 완료")
                promise(.success(()))
                
            } errorHandler: { _ in
                print("버스킹 등록 요청 실패")
            }
            
        }
        .eraseToAnyPublisher()
    }
}
