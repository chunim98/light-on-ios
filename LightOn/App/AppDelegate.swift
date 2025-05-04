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
        // 카카오톡 소셜 로그인 모듈 초기화
        let kakaoAppKey = Bundle.main.infoDictionary?["KakaoNativeAppKey"] as! String
//        KakaoSDK.initSDK(appKey: kakaoAppKey)

        return true
    }
}

