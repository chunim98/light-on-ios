//
//  LoginRequestDTO.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
    
    init(from domain: LoginState) {
        self.email = domain.email
        self.password = domain.pw
    }
}
