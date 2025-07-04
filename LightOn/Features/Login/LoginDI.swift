//
//  LoginDI.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

final class LoginDI {
    
    // MARK: Singleton
    
    static let shared = LoginDI()
    private init() {}
    
    // MARK: Methods
    
    func makeLoginVM() -> LoginVM {
        LoginVM.init(loginRepo: DefaultLoginRepo())
    }
}
