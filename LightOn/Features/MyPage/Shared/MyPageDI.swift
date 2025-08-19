//
//  MyPageDI.swift
//  LightOn
//
//  Created by 신정욱 on 8/10/25.
//

final class MyPageDI {
    
    // MARK: Singleton
    
    static let shared = MyPageDI()
    private init() {}
    
    // MARK: Methods
    
    func makeMyPageLoginHeaderVM() -> MyPageLoginHeaderVM {
        MyPageLoginHeaderVM(repo: DefaultMyInfoRepo())
    }
    
    func makeLogoutAlertVM() -> LogoutAlertVM {
        LogoutAlertVM(repo: DefaultLogoutRepo())
    }
    
    func makeDeleteAccountAlertVM() -> DeleteAccountAlertVM {
        DeleteAccountAlertVM(repo: DefaultDeleteAccountRepo())
    }
}
