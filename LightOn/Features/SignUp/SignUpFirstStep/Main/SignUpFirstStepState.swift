//
//  SignUpFirstStepState.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

struct SignUpFirstStepState {
    let email: String?
    let password: String?
    let confirmPassword: String?
    
    func updated(
        email: String?? = nil,
        password: String?? = nil,
        confirmPassword: String?? = nil
    ) -> SignUpFirstStepState {
        SignUpFirstStepState(
            email: email ?? self.email,
            password: password ?? self.password,
            confirmPassword: confirmPassword ?? self.confirmPassword
        )
    }
}
