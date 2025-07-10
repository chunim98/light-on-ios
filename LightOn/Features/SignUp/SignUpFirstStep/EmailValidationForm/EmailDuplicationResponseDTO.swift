//
//  EmailDuplicationResponseDTO.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

struct EmailDuplicationResponseDTO: Decodable {
    let isDuplicate: Bool
    
    func toDomain() -> EmailValidationFormState.Duplication {
        isDuplicate ? .duplicated  : .notDuplicated
    }
}
