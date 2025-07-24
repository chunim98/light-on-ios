//
//  AppDelegate.swift
//  LightOn
//
//  Created by 신정욱 on 4/28/25.
//

import UIKit

import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        TokenKeychain.shared.clear()        // 앱 재설치 후, 잔여토큰 초기화
        
        // 카카오톡 소셜 로그인 모듈 초기화
        // let kakaoAppKey = Bundle.main.infoDictionary?["KakaoNativeAppKey"] as! String
        // KakaoSDK.initSDK(appKey: kakaoAppKey)
        
        Thread.sleep(forTimeInterval: 0.75) // 스플래시 이미지 표시
        return true
    }
}

