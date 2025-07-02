//
//  MemberInfoRequestDTO.swift
//  LightOn
//
//  Created by 신정욱 on 7/1/25.
//


struct MemberInfoRequestDTO: Encodable {
    let name: String
    let phone: String
    let regionCode: Int
    let agreements: Agreements
    
    init?(from domain: MemberInfo) {
        guard let name = domain.name,
              let phone = domain.phone,
              let regionCode = domain.regionCode
        else { return nil }
        
        let marketing = Agreements.Marketing(
            sms: domain.smsAgreed,
            push: domain.pushAgreed,
            email: domain.emailAgreed
        )
        
        let agreememts = Agreements(
            terms: domain.termsAgreed,
            privacy: domain.termsAgreed,
            over14: domain.termsAgreed,
            marketing: marketing
        )
        
        self.name = name
        self.phone = phone
        self.regionCode = regionCode
        self.agreements = agreememts
    }
    
    struct Agreements: Encodable {
        let terms: Bool
        let privacy: Bool
        let over14: Bool
        let marketing: Marketing
        
        struct Marketing: Encodable {
            let sms: Bool
            let push: Bool
            let email: Bool
        }
    }
}
