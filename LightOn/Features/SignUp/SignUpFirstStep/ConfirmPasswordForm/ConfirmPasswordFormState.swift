//
//  ConfirmPasswordFormState.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

struct ConfirmPasswordFormState {
    
    enum Matching { case unknown, originBadFormat, matched, notMatched }
    
    let confirmPassword: String
    let matchingState: Matching

    func updated(
        confirmPassword: String? = nil,
        matchingState: Matching? = nil
    ) -> ConfirmPasswordFormState {
        ConfirmPasswordFormState(
            confirmPassword: confirmPassword ?? self.confirmPassword,
            matchingState: matchingState ?? self.matchingState
        )
    }
}
