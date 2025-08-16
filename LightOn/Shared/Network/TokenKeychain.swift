//
//  TokenKeychain.swift
//  LightOn
//
//  Created by 신정욱 on 6/8/25.
//

import Foundation
import Security

final class TokenKeychain: @unchecked Sendable {
    
    // MARK: Enum
    
    enum TokenType: String { case access, refresh, fcm }
    
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
        
        SecItemDelete(query)                // 기존 항목 제거(기존 값이 있으면 안됨)
        let status = SecItemAdd(query, nil) // 새 항목 추가
        
        if status == errSecSuccess {
            print("[TokenKeychain] \(type.rawValue) 저장 성공!")
        } else if status == errSecDuplicateItem {
            print("[TokenKeychain] \(type.rawValue) 중복 저장!")
        } else {
            print("[TokenKeychain] \(type.rawValue) 저장 실패! \(status)")
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
            print("[TokenKeychain] \(type.rawValue) 읽기 실패! \(status)")
            return nil
        }
    }
    
    /// 토큰 삭제
    func delete(_ type: TokenType) {
        let query = [
            kSecClass:          kSecClassGenericPassword,
            kSecAttrAccount:    type.rawValue
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        if status == errSecSuccess {
            print("[TokenKeychain] \(type.rawValue) 삭제 성공!")
        } else if status == errSecItemNotFound {
            print("[TokenKeychain] \(type.rawValue) 삭제할 항목 없음!")
        } else {
            print("[TokenKeychain] \(type.rawValue) 삭제 실패! \(status)")
        }
    }
}
