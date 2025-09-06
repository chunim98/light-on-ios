//
//  ModifyConcertRepo.swift
//  LightOn
//
//  Created by 신정욱 on 9/6/25.
//

import Foundation
import Combine

import Alamofire

protocol ModifyConcertRepo {
    /// 공연 상세정보 조회
    /// - 단 결제 정보는 누락되어 있음(fetchPaymentInfo에서 조회)
    func fetchConcertInfo(id: Int) -> AnyPublisher<RegisterConcertInfo, Never>
    
    /// 결제 정보 조회
    /// - 가격은 fetchConcertInfo의 것을 사용
    func fetchPaymentInfo(id: Int) -> AnyPublisher<PaymentInfo, Never>
    
    /// 콘서트 수정 요청
    func requestEditConcert(
        id: Int,
        info: RegisterConcertInfo,
        posterData: Data?,
        documentData: Data?
    ) -> AnyPublisher<Void, Never>
    
    /// 콘서트 취소 요청
    func requestDeleteConcert(id: Int) -> AnyPublisher<Void, Never>
}

// MARK: - Default

final class DefaultModifyConcertRepo: ModifyConcertRepo {
    func fetchConcertInfo(id: Int) -> AnyPublisher<RegisterConcertInfo, Never> {
        Future { promise in
            
            APIClient.plain.request(
                BaseURL + "/api/members/performances/\(id)",
                method: .get
            )
            .decodeResponse(decodeType: PerformanceDetailResDTO.self) {
                print("[ModifyConcertRepo] 콘서트 상세정보 조회 완료")
                promise(.success($0.toConcertInfo()))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func fetchPaymentInfo(id: Int) -> AnyPublisher<PaymentInfo, Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/members/performances/\(id)/payment",
                method: .get,
                parameters: ["applySeats": 1]
            )
            .decodeResponse(decodeType: PaymentInfoResDTO.self) {
                print("[ModifyConcertRepo] 결제 정보 조회 완료")
                promise(.success($0.toDomain()))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func requestEditConcert(
        id: Int,
        info: RegisterConcertInfo,
        posterData: Data?,
        documentData: Data?
    ) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            // jsonData 생성
            guard let jsonData = try? JSONEncoder().encode(
                RegisterConcertReqDTO(from: info)
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
                to: BaseURL + "/api/artists/performances/\(id)",
                method: .put
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                print("[ModifyConcertRepo] 콘서트 수정요청 완료")
                promise(.success(()))
                
            } errorHandler: { _ in
                print("[ModifyConcertRepo] 콘서트 수정요청 실패")
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func requestDeleteConcert(id: Int) -> AnyPublisher<Void, Never> {
        Future { promise in
            
            APIClient.withAuth.request(
                BaseURL + "/api/artists/performances/\(id)",
                method: .delete
            )
            .decodeResponse(decodeType: EmptyDTO.self) { _ in
                print("[ModifyConcertRepo] 콘서트 취소 요청 완료")
                promise(.success(()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
