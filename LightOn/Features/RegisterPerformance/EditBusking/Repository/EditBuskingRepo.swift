//
//  EditBuskingRepo.swift
//  LightOn
//
//  Created by 신정욱 on 8/21/25.
//

import Foundation
import Combine

import Alamofire

protocol EditBuskingRepo {
    /// 공연 상세정보 조회
    func getBuskingInfo(id: Int) -> AnyPublisher<BuskingInfo, Never>
    
    /// 버스킹 수정 요청
    func requestEditBusking(
        id: Int,
        info: BuskingInfo,
        posterData: Data?,
        documentData: Data?
    ) -> AnyPublisher<Void, Never>
}

// MARK: - Default

final class DefaultEditBuskingRepo: EditBuskingRepo {
    func getBuskingInfo(id: Int) -> AnyPublisher<BuskingInfo, Never> {
        Future { promise in
            
            APIClient.plain.request(
                BaseURL + "/api/members/performances/\(id)",
                method: .get
            )
            .decodeResponse(decodeType: PerformanceDetailResDTO.self) {
                print("[EditBuskingRepo] 공연 상세정보 조회 완료")
                promise(.success($0.toBuskingInfo()))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func requestEditBusking(
        id: Int,
        info: BuskingInfo,
        posterData: Data?,
        documentData: Data?
    ) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            /// 아티스트 상태면 아티스트 버스킹으로 수정
            let endpoint = SessionManager.shared.isArtist
            ? "/api/artists/performances/buskings/\(id)"
            : "/api/members/performances/buskings/\(id)"
            
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
                    if let documentData {
                        formData.append(
                            documentData,
                            withName: "proof",
                            fileName: "proof.png"
                        )
                    }
                    // 포스터 이미지 전송
                    if let posterData {
                        formData.append(
                            posterData,
                            withName: "posterImage",
                            fileName: "posterImage.png"
                        )
                    }
                },
                to: BaseURL + endpoint,
                method: .put
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                print("[EditBuskingRepo] 버스킹 수정요청 완료")
                promise(.success(()))
                
            } errorHandler: { _ in
                print("[EditBuskingRepo] 버스킹 수정요청 실패")
            }
            
        }
        .eraseToAnyPublisher()
    }
    
}
