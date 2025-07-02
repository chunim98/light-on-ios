//
//  MemberInfo.swift
//  LightOn
//
//  Created by 신정욱 on 7/1/25.
//

struct MemberInfo {
    let tempMemberID: Int
    let name: String?
    let phone: String?
    let regionCode: Int?
    let termsAgreed: Bool
    let smsAgreed: Bool
    let pushAgreed: Bool
    let emailAgreed: Bool
    
    func updated(
        name: String?? = nil,
        phone: String?? = nil,
        regionCode: Int?? = nil,
        termsAgreed: Bool? = nil,
        smsAgreed: Bool? = nil,
        pushAgreed: Bool? = nil,
        emailAgreed: Bool? = nil
    ) -> MemberInfo {
        MemberInfo(
            tempMemberID: self.tempMemberID,
            name: name ?? self.name,
            phone: phone ?? self.phone,
            regionCode: regionCode ?? self.regionCode,
            termsAgreed: termsAgreed ?? self.termsAgreed,
            smsAgreed: smsAgreed ?? self.smsAgreed,
            pushAgreed: pushAgreed ?? self.pushAgreed,
            emailAgreed: emailAgreed ?? self.emailAgreed
        )
    }
}
