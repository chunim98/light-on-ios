//
//  PasswordValidationFormState.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

struct PasswordValidationFormState {
    
    enum Format { case unknown, valid, invalid }
    
    let password: String
    let format: Format
    
    func updated(
        password: String? = nil,
        format: Format? = nil
    ) -> PasswordValidationFormState {
        PasswordValidationFormState(
            password: password ?? self.password,
            format: format ?? self.format
        )
    }
}
