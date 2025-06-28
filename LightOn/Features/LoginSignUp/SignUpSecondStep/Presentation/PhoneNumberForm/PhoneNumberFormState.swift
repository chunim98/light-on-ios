//
//  PhoneNumberFormState.swift
//  LightOn
//
//  Created by 신정욱 on 6/29/25.
//

struct PhoneNumberFormState {
    let phoneNumber: String
    let authCode: String
    let time: String
    let authCodeHStackHidden: Bool
    let requestButtonEnabled: Bool
    let confirmButtonEnabled: Bool
    
    func updated(
        phoneNumber: String? = nil,
        authCode: String? = nil,
        time: String? = nil,
        authCodeHStackHidden: Bool? = nil,
        requestButtonEnabled: Bool? = nil,
        confirmButtonEnabled: Bool? = nil
    ) -> PhoneNumberFormState {
        return PhoneNumberFormState(
            phoneNumber: phoneNumber ?? self.phoneNumber,
            authCode: authCode ?? self.authCode,
            time: time ?? self.time,
            authCodeHStackHidden: authCodeHStackHidden ?? self.authCodeHStackHidden,
            requestButtonEnabled: requestButtonEnabled ?? self.requestButtonEnabled,
            confirmButtonEnabled: confirmButtonEnabled ?? self.confirmButtonEnabled
        )
    }
}

