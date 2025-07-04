//
//  DuplicationStateResponseDTO.swift
//  LightOn
//
//  Created by 신정욱 on 6/2/25.
//

struct DuplicationStateResponseDTO: Decodable {
    let isDuplicate: Bool
    
    func toDomain() -> DuplicationState {
        isDuplicate ? .duplicated : .verified
    }
}
