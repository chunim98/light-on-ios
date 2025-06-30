//
//  PhoneNumberVerificationRequestDTO.swift
//  LightOn
//
//  Created by 신정욱 on 6/30/25.
//

struct PhoneNumberVerificationRequestDTO: Encodable {
    let phoneNumber: String
    let code: String
    
    init(from domain: PhoneNumberFormState) {
        self.phoneNumber = domain.phoneNumber
        self.code = domain.authCode
    }
}
