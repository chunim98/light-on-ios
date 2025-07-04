//
//  PhoneNumberFormStyle.swift
//  LightOn
//
//  Created by 신정욱 on 6/30/25.
//

struct PhoneNumberFormStyle {
    let authCodeHStackHidden: Bool
    let captionViewHidden: Bool
    let requestButtonEnabled: Bool
    let confirmButtonEnabled: Bool
    
    static var initial: PhoneNumberFormStyle {
        PhoneNumberFormStyle(
            authCodeHStackHidden: true,
            captionViewHidden: true,
            requestButtonEnabled: false,
            confirmButtonEnabled: false
        )
    }
    
    static var canRequest: PhoneNumberFormStyle {
        PhoneNumberFormStyle(
            authCodeHStackHidden: true,
            captionViewHidden: true,
            requestButtonEnabled: true,
            confirmButtonEnabled: false
        )
    }
    
    static var inProcess: PhoneNumberFormStyle {
        PhoneNumberFormStyle(
            authCodeHStackHidden: false,
            captionViewHidden: true,
            requestButtonEnabled: false,
            confirmButtonEnabled: true
        )
    }
    
    static var timeOver: PhoneNumberFormStyle {
        PhoneNumberFormStyle(
            authCodeHStackHidden: false,
            captionViewHidden: true,
            requestButtonEnabled: false,
            confirmButtonEnabled: false
        )
    }
    
    static var verified: PhoneNumberFormStyle {
        PhoneNumberFormStyle(
            authCodeHStackHidden: true,
            captionViewHidden: false,
            requestButtonEnabled: false,
            confirmButtonEnabled: false
        )
    }
}
