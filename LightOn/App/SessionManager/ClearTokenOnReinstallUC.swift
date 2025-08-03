//
//  ClearTokenOnReinstallUC.swift
//  LightOn
//
//  Created by 신정욱 on 8/3/25.
//

final class ClearTokenOnReinstallUC {
    
    /// 앱 설치 후 최초 실행 여부 (키체인 초기화 용도)
    @Storage("isFirstLaunch", true) var isFirstLaunch: Bool
    
    /// 앱 재설치 후, 잔여토큰 초기화
    func execute() {
        guard isFirstLaunch else { return }
        TokenKeychain.shared.delete(.access)
        TokenKeychain.shared.delete(.refresh)
        TokenKeychain.shared.delete(.fcm)
        isFirstLaunch = false
    }
}
