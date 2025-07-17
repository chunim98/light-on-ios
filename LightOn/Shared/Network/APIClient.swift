//
//  APIClient.swift
//  LightOn
//
//  Created by 신정욱 on 6/5/25.
//

import Foundation

import Alamofire

final class APIClient {
    
    // MARK: Singleton
    
    static let shared = APIClient()
    private init() {}
    
    // MARK: Properties
    
    private let rootURL = APIConstants.lightOnRootURL
    
    /// 토큰 재발급 요청 횟수 (재발급 루프 방지)
    private var reissueCount = 0
    
    // MARK: Mathods
    
    /// GET 요청 수행
    func requestGet<ResponseDTO: Decodable>(
        endPoint: String,
        parameters: Parameters? = nil,
        tokenIncluded: Bool = true,
        decodeType: ResponseDTO.Type,
        completion: @escaping (ResponseDTO) -> Void,
        errorHandler: ((APIErrorDTO) -> Void)? = nil
    ) {
        let interceptor = tokenIncluded ? APITokenInterceptor() : nil
        
        // 네트워크 통신 시작
        let request = AF.request(
            rootURL + endPoint,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default, // URL로 쿼리
            interceptor: interceptor
        )
        
        // 통신 결과 처리
        decodeResponse(
            request: request,
            decodeType: decodeType,
            completion: completion,
            errorHandler: errorHandler
        )
    }
    
    /// POST 요청 수행
    func requestPost<
        Parameters: Encodable & Sendable,
        ResponseDTO: Decodable
    >(
        endPoint: String,
        parameters: Parameters?,
        headers: HTTPHeaders? = nil,
        tokenIncluded: Bool = true,
        decodeType: ResponseDTO.Type,
        completion: @escaping (ResponseDTO) -> Void,
        errorHandler: ((APIErrorDTO) -> Void)? = nil
    ) {
        let interceptor = tokenIncluded ? APITokenInterceptor() : nil
        
        // 네트워크 통신 시작
        let request = AF.request(
            rootURL + endPoint,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default, // Encodable객체 -> JSON
            headers: headers,
            interceptor: interceptor
        )
        
        // 통신 결과 처리
        decodeResponse(
            request: request,
            decodeType: decodeType,
            completion: completion,
            errorHandler: errorHandler
        )
    }
    
    /// 리스폰스 파싱
    func decodeResponse<ResponseDTO: Decodable>(
        request: DataRequest,
        decodeType: ResponseDTO.Type,
        completion: @escaping (ResponseDTO) -> Void,
        errorHandler: ((APIErrorDTO) -> Void)?
    ) {
#if DEBUG
        request.cURLDescription {
            print("\nAPIClient: 요청 상세 ===============================\n\($0)\n")
        }
        
        request.responseData {
            guard let data = $0.data, let rawString = String(data: data, encoding: .utf8)
            else { return }
            print("\nAPIClient: 응답 상세 ===============================\n\(rawString)\n")
        }
#endif
        
        request.responseDecodable(
            of: APIResultObjectDTO<ResponseDTO>.self
        ) { response in
            
            switch response.result {
            case .success(let resultDTO):
                
                let statusCode = response.response?.statusCode ?? -1
                
                print("APIClient: success", resultDTO.success)
                
                if (200..<300).contains(statusCode) {
                    resultDTO.response.map { completion($0) }
                    
                } else {
                    resultDTO.error.map {
                        print("APIClient: error message", $0.message)
                        print("APIClient: error status", $0.status)
                        errorHandler?($0)
                    }
                }
                
            case .failure(let afError):
                print("APIClient: AFError", afError)    // 어떤 에러인지 로그
            }
        }
    }
    
    /// 토큰 재발급
    func reissueToken(
        completion: @escaping () -> Void,
        errorHandler: (() -> Void)? = nil
    ) {
        guard let refreshToken = TokenKeychain.shared.load(.refresh)
        else { errorHandler?(); return }
        
        guard reissueCount <= 10
        else { print("APIClient: 토큰 재발급 횟수 초과"); errorHandler?(); return }
        reissueCount += 1
        
        APIClient.shared.requestPost(
            endPoint: "/api/auth/token/refresh",
            parameters: Optional<EmptyDTO>.none,            // 파라미터 없음
            headers: ["Refresh-Token": refreshToken],
            tokenIncluded: false,                           // 인터셉터 없음
            decodeType: TokenResponseDTO.self
        ) {
            TokenKeychain.shared.save(.access, token: $0.accessToken)
            TokenKeychain.shared.save(.refresh, token: $0.refreshToken)
            completion()
            
        } errorHandler: { _ in
            print("APIClient: 토큰 재발급 실패")
            errorHandler?()
        }
    }
}
