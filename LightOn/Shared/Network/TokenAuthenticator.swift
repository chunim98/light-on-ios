//
//  TokenAuthenticator.swift
//  LightOn
//
//  Created by 신정욱 on 8/3/25.
//

import Foundation

import Alamofire

final class TokenAuthenticator: Authenticator {
    
    typealias Credential = TokenCredential
    
    /// 요청에 인증 정보를 적용
    /// - AccessToken을 Authorization 헤더에 Bearer 형태로 추가
    func apply(
        _ credential: TokenCredential,
        to urlRequest: inout URLRequest
    ) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }
    
    /// 요청이 인증 실패로 실패했는지 여부 판단
    /// - 보통 401 상태코드만 인증 실패로 간주
    func didRequest(
        _ urlRequest: URLRequest,
        with response: HTTPURLResponse,
        failDueToAuthenticationError error: any Error
    ) -> Bool {
        return response.statusCode == 401
    }
    
    /// 요청이 현재 Credential로 인증되어 발송된 것인지 확인
    /// - true: 요청에 사용된 토큰이 현재 Credential과 동일
    ///         → 401 발생 시, 만료된 토큰으로 요청했을 가능성이 있어 토큰 갱신 시작
    /// - false: 요청에 이미 다른(새로운) 토큰이 사용됨
    ///         → 단순 재시도만 수행
    func isRequest(
        _ urlRequest: URLRequest,
        authenticatedWith credential: TokenCredential
    ) -> Bool {
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }
    
    /// 토큰 재발급 처리
    /// - Alamofire의 AuthenticationInterceptor가 호출
    /// - 이미 갱신 중이면 Alamofire가 요청을 큐에 보관 후, 갱신 완료 시 큐에 있는 요청을 모두 재시도함
    func refresh(
        _ credential: TokenCredential,
        for session: Alamofire.Session,
        completion: @escaping @Sendable (Result<TokenCredential, any Error>) -> Void
    ) {
        APIClient.plain.request(
            BaseURL + "/api/auth/token/refresh",
            method: .post,
            headers: ["Refresh-Token": credential.refreshToken]
        )
        .decodeResponse(decodeType: TokenResponseDTO.self) {
            print("[TokenAuthenticator] 토큰 재발급 성공")
            let token = $0.toDomain()
            TokenKeychain.shared.save(.access, token: token.accessToken)
            TokenKeychain.shared.save(.refresh, token: token.refreshToken)
            completion(.success(TokenCredential()))
            
        } errorHandler: {
            print("[TokenAuthenticator] 토큰 재발급 실패")
            TokenKeychain.shared.delete(.access)
            TokenKeychain.shared.delete(.refresh)
            TokenKeychain.shared.delete(.fcm)
            SessionManager.shared.updateLoginState()
            completion(.failure($0.toDomain()))
        }
    }
}
