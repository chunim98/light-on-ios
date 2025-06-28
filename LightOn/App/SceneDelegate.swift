//
//  SceneDelegate.swift
//  LightOn
//
//  Created by 신정욱 on 4/28/25.
//

import UIKit

import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: Properties

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    // MARK: Methods

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)

        appCoordinator = AppCoordinator()
        window?.rootViewController = appCoordinator?.navigation
        appCoordinator?.start()
        
        window?.makeKeyAndVisible()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // 씬이 활성화 됐을 때 로그인 상태 확인
        SessionManager.shared.updateLoginState()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        // 카카오톡 앱으로 로그인 할 때, 리디렉션 콜백을 받고 현재 앱으로 복귀
        if AuthApi.isKakaoTalkLoginUrl(url) { _ = AuthController.handleOpenUrl(url: url) }
    }
}

