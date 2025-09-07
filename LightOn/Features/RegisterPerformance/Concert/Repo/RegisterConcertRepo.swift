//
//  RegisterConcertRepo.swift
//  LightOn
//
//  Created by 신정욱 on 9/6/25.
//

import Foundation
import Combine

import Alamofire

protocol RegisterConcertRepo {
    /// 콘서트 등록 요청
    func requestRegisterConcert(
        info: ConcertInfo,
        posterData: Data,
        documentData: Data
    ) -> AnyPublisher<Void, Never>
}

// MARK: - Default

final class DefaultRegisterConcertRepo: RegisterConcertRepo {
    func requestRegisterConcert(
        info: ConcertInfo,
        posterData: Data,
        documentData: Data
    ) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            // jsonData 생성
            guard let jsonData = try? JSONEncoder().encode(
                RegisterConcertReqDTO(from: info)
            ) else { return }
            
            print(String(data: jsonData, encoding: .utf8))
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
                to: BaseURL + "/api/artists/performances/concerts"
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                print("[RegisterConcertRepo] 콘서트 등록 요청 완료")
                promise(.success(()))
                
            } errorHandler: { _ in
                print("[RegisterConcertRepo] 콘서트 등록 요청 실패")
            }
            
        }
        .eraseToAnyPublisher()
    }
}
