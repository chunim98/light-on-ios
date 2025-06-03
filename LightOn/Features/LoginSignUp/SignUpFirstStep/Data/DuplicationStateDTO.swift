//
//  DuplicationStateDTO.swift
//  LightOn
//
//  Created by 신정욱 on 6/2/25.
//

struct DuplicationStateDTO: Decodable {
    let success: Bool
    let response: Response?
    let error: LightOnAPIErrorDTO?
    
    struct Response: Decodable {
        let isDuplicate: Bool
        
        func toDomain() -> DuplicationState {
            self.isDuplicate ? .duplicated : .verified
        }
    }
}
