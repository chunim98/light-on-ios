//
//  EmailValidationFormState.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

struct EmailValidationFormState {
    
    enum Duplication { case unknown, duplicated, notDuplicated }
    enum Format { case unknown, valid, invalid }
    
    let email: String
    let duplication: Duplication
    let format: Format
    
    func updated(
        email: String? = nil,
        duplication: Duplication? = nil,
        format: Format? = nil
    ) -> EmailValidationFormState {
        EmailValidationFormState(
            email: email ?? self.email,
            duplication: duplication ?? self.duplication,
            format: format ?? self.format
        )
    }
}
