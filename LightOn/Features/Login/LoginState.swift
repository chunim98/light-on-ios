//
//  LoginState.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

struct LoginState {
    let email: String
    let pw: String
    
    func updated(
        email: String? = nil,
        pw: String? = nil
    ) -> LoginState {
        LoginState(
            email: email ?? self.email,
            pw: pw ?? self.pw
        )
    }
}
