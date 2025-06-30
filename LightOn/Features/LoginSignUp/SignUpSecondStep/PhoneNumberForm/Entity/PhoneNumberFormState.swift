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
    let isVerified: Bool
    let style: PhoneNumberFormStyle
    
    func updated(
        phoneNumber: String? = nil,
        authCode: String? = nil,
        time: String? = nil,
        isVerified: Bool? = nil,
        style: PhoneNumberFormStyle? = nil
    ) -> PhoneNumberFormState {
        return PhoneNumberFormState(
            phoneNumber: phoneNumber ?? self.phoneNumber,
            authCode: authCode ?? self.authCode,
            time: time ?? self.time,
            isVerified: isVerified ?? self.isVerified,
            style: style ?? self.style
        )
    }
}

