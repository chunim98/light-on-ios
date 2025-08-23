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
        info: BuskingInfo,
        posterData: Data,
        documentData: Data
    ) -> AnyPublisher<Void, Never>
}

// MARK: - Default

final class DefaultRegisterBuskingRepo: RegisterBuskingRepo {
    func requestRegisterBusking(
        info: BuskingInfo,
        posterData: Data,
        documentData: Data
    ) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            // jsonData 생성
            guard let jsonData = try? JSONEncoder().encode(
                RegisterBuskingReqDTO(from: info)
            ) else { return }
            
            // 서버에 전송 요청
            APIClient.withAuth.upload(
                multipartFormData: { formData in
                    // json 텍스트로 만들어서 전송
                    formData.append(
                        jsonData,
                        withName: "data",
                        mimeType: "application/json"
                    )
                    // 증빙자료 전송
                    formData.append(
                        documentData,
                        withName: "proof",
                        fileName: "proof.png"
                    )
                    // 포스터 이미지 전송
                    formData.append(
                        posterData,
                        withName: "posterImage",
                        fileName: "posterImage.png"
                    )
                },
                to: BaseURL + "/api/members/performances/buskings"
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                print("[RegisterBuskingRepo] 버스킹 등록 요청 완료")
                promise(.success(()))
                
            } errorHandler: { _ in
                print("[RegisterBuskingRepo] 버스킹 등록 요청 실패")
            }
            
        }
        .eraseToAnyPublisher()
    }
}
