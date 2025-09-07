//
//  MyInfoResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 8/10/25.
//


struct MyInfoResDTO: Decodable {
    let id: Int
    let name: String
    let email: String
}

// MARK: Mapper

extension MyInfoResDTO {
    func toDomain() -> MyInfo {
        MyInfo(
            id: String(id),
            name: name,
            email: email
        )
    }
}
