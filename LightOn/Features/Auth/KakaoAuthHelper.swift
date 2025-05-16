//
//  KakaoAuthHelper.swift
//  LightOn
//
//  Created by 신정욱 on 4/28/25.
//


import Foundation
import Combine

import KakaoSDKUser

final class KakaoAuthHelper: NSObject {
    
    // MARK: Outputs
    
    private let resultTextSubject = PassthroughSubject<String, Never>()
    
    // MARK: Methods
    
    private func signIn() {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self?.resultTextSubject.send(error.localizedDescription)
                    
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    // 성공 시 동작 구현
                    let accessToken = oauthToken?.accessToken.prefix(10) ?? "nil"
                    
                    let resultText = """
                                     카카오 로그인에 성공하였습니다.
                                     
                                     accessToken: \(accessToken)...
                                     """
                    self?.resultTextSubject.send(resultText)
                }
            }
        }
    }
}

// MARK: Binders & Publishers

extension KakaoAuthHelper {
    func signInBinder() { signIn() }
    
    var resultTextPublisher: AnyPublisher<String, Never> {
        resultTextSubject.eraseToAnyPublisher()
    }
}
