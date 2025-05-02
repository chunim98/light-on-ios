//
//  DefaultKakaoAuthResultRepository.swift
//  LightOn
//
//  Created by 신정욱 on 5/2/25.
//

import Combine

import KakaoSDKUser

final class DefaultKakaoAuthResultRepository: KakaoAuthResultRepository {
    func fetchAuthResult() -> AnyPublisher<KakaoAuthResult, Error> {
        return Future { promise in
            // 카카오톡 실행 가능 여부 확인
            guard UserApi.isKakaoTalkLoginAvailable() else { return }
            
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error {
                    // 실패 시
                    print(error.localizedDescription)
                    promise(.failure(error))
                    
                } else {
                    // 성공 시
                    print("loginWithKakaoTalk() success.")
                    
                    let accessToken = oauthToken?.accessToken.prefix(10) ?? "nil"
                    
                    let resultText = """
                                     카카오 로그인에 성공하였습니다.
                                     
                                     accessToken: \(accessToken)...
                                     """
                    let result = KakaoAuthResult(
                        userID: "any user id",
                        accessToken: String(accessToken)
                    )
                    
                    promise(.success(result))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
