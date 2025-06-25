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
}
