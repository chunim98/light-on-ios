//
//  AuthCodeRequestDTO.swift
//  LightOn
//
//  Created by 신정욱 on 6/29/25.
//

struct AuthCodeRequestDTO: Encodable {
    let phoneNumber: String
    
    init(from domain: PhoneNumberFormState) {
        self.phoneNumber = domain.phoneNumber
    }
}
