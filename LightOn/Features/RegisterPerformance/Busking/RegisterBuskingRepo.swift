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
            
            // 엔드포인트 설정
            let baseURL = APIConstants.lightOnRootURL
            let endPoint = "/api/members/performances/buskings"
            
            // 서버에 전송 요청
            let request = AF.upload(
                multipartFormData: { multipartFormData in
                    // json 텍스트로 만들어서 전송
                    multipartFormData.append(
                        jsonData,
                        withName: "data",
                        mimeType: "application/json"
                    )
                    // 포스터 이미지 전송
                    multipartFormData.append(
                        posterData,
                        withName: "posterImage",
                        mimeType: "image/png"
                    )
                    // 증빙자료 전송
                    multipartFormData.append(
                        documentData,
                        withName: "proof",
                        mimeType: "image/png"
                    )
                },
                to: baseURL + endPoint,
                interceptor: APITokenInterceptor()
            )
            
            // 결과 파싱
            APIClient.shared.decodeResponse(
                request: request,
                decodeType: EmptyDTO.self
            ) { _ in
                print("버스킹 등록 요청 완료")
                promise(.success(()))
                
            } errorHandler: { _ in
                print("버스킹 등록 요청 실패")
            }
            
        }
        .eraseToAnyPublisher()
    }
}
