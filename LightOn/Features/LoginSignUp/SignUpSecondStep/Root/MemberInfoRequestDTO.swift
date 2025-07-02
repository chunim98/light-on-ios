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
