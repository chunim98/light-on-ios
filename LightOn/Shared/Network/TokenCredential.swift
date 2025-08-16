//
//  TokenCredential.swift
//  LightOn
//
//  Created by 신정욱 on 8/3/25.
//

import Foundation

import Alamofire

struct TokenCredential {
    
    // MARK: Properties
    
    var accessToken: String? { TokenKeychain.shared.load(.access) }
    var refreshToken: String? { TokenKeychain.shared.load(.refresh) }
    
    var accessExpireAt: Date? { parseTokenExpiration(accessToken) }
    var refreshExpireAt: Date? { parseTokenExpiration(refreshToken) }
    
    // MARK: Private Helper
    
    /// 토큰 유효기간 파싱
    private func parseTokenExpiration(_ token: String?) -> Date? {
        guard let token else { return nil }
        
        // 토큰을 . 으로 분리
        let segments = token.components(separatedBy: ".")
        guard let payloadSegment = segments[safe: 1] else { return nil }
        
        // Base64 디코딩
        var base64 = payloadSegment
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        // padding 복구
        while base64.count%4 != 0 { base64 += "=" }
        
        guard
            let payloadData = Data(base64Encoded: base64),
            let payloadJSON = try? JSONSerialization
                .jsonObject(with: payloadData) as? [String: Any],
            let exp = payloadJSON["exp"] as? TimeInterval
        else { return nil }
        
        return Date(timeIntervalSince1970: exp)
    }
}

// MARK: - AuthenticationCredential

extension TokenCredential: AuthenticationCredential {
    /// 토큰 갱신이 필요한지 여부 (만료 5분 전  갱신)
    var requiresRefresh: Bool {
        guard let refreshExpireAt else { return true }
        return Date(timeIntervalSinceNow: 60*5) > refreshExpireAt
    }
}
