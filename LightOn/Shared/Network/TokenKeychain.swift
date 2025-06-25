//
//  TokenKeychain.swift
//  LightOn
//
//  Created by 신정욱 on 6/8/25.
//

import Foundation
import Security

final class TokenKeychain: Sendable {
    
    // MARK: Enum
    
    enum TokenType: String { case access, refresh }
    
    // MARK: Singletone
    
    static let shared = TokenKeychain()
    private init() {}

    // MARK: Methods
    
    /// 토큰 저장
    func save(_ type: TokenType, token: String) {
        guard let tokenData = token.data(using: .utf8) else { return }
        
        let query = [
            kSecClass:          kSecClassGenericPassword,
            kSecAttrAccount:    type.rawValue,
            kSecValueData:      tokenData
        ] as CFDictionary
        
        SecItemDelete(query) // 기존 항목 제거(기존 값이 있으면 안됨)
        let status = SecItemAdd(query, nil)
        
        if status == errSecSuccess {
            print("TokenKeychain: 저장 성공이다냥!")
        } else if status == errSecDuplicateItem {
            print("TokenKeychain: 이미 존재하는 항목이다냥! (중복)")
        } else {
            print("TokenKeychain: 저장 실패다냥! 에러 코드: \(status)")
        }
    }
    
    /// 토큰 불러오기
    func load(_ type: TokenType) -> String? {
        let query = [
            kSecClass:          kSecClassGenericPassword,
            kSecAttrAccount:    type.rawValue,
            kSecReturnData:     true,
            kSecMatchLimit:     kSecMatchLimitOne // 중복되는 경우, 하나의 값만 불러오라는 의미
        ] as CFDictionary
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess,
           let retrievedData = dataTypeRef as? Data,
           let token = String(data: retrievedData, encoding: .utf8) {
            return token
            
        } else {
            print("TokenKeychain: \(type.rawValue)토큰 읽기 실패! 에러코드: \(status)")
            return nil
        }
    }
    
    /// 토큰의 유효기간 가져오기
    func getEXP(_ type: TokenType) -> Date? {
        guard let token = load(.access) else { return nil }
        
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
