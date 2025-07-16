//
//  APITokenInterceptor.swift
//  LightOn
//
//  Created by 신정욱 on 6/7/25.
//

import Foundation

import Alamofire

final class APITokenInterceptor: RequestInterceptor {
    
    // MARK: Repository
    
    private let keychain = TokenKeychain.shared

    // MARK: RequestInterceptor Methods
    
    /// 서버로 리퀘스트가 나가기 전 호출됨
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        print("어댑터 접근")
        
        let access = keychain.load(.access) ?? ""
        var urlRequest = urlRequest
        
        // 토큰에 Bearer 붙여서 헤더에 넣기
        urlRequest.headers.add(.authorization(bearerToken: access))
        completion(.success(urlRequest))
    }

    /// 예외 발생으로, 재시도를 시도할 때 호출됨
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard request.response?.statusCode == 401 else {
            completion(.doNotRetry) // 401 인증오류만 처리함
            return
        }
        
        print("APIInterceptor: 토큰 재발급 시도중...")
        
        reissueToken {
            print("APIInterceptor: 토큰 재발급 성공, 통신 재시도")
            completion(.retry)
            
        } errorHandler: {
            print("APIInterceptor: 토큰 재발급 실패, 통신 재시도 포기")
            completion(.doNotRetry)
        }
    }
    
    // MARK: Private Helper
    
    /// 토큰 재발급
    private func reissueToken(
        completion: @escaping () -> Void,
        errorHandler: (() -> Void)? = nil
    ) {
        guard let refreshToken = TokenKeychain.shared.load(.refresh)
        else { errorHandler?(); return }
        
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
            print(#function, "토큰 재발급 실패")
            errorHandler?()
        }
    }
}
