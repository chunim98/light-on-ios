//
//  PaymentInfoResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 7/24/25.
//

struct PaymentInfoResDTO: Decodable {
    let account: String?
    let bank: String?
    let accountHolder: String?
    let fee: Int
    
    func toDomain() -> PaymentInfo {
        PaymentInfo(
            accountNumber:  account,
            bank:           bank,
            accountHolder:  accountHolder,
            amount:         fee
        )
    }
}
