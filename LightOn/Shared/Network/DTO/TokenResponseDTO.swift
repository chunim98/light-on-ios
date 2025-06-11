//
//  UserTokenResponseDTO.swift
//  TennisPark
//
//  Created by 신정욱 on 6/8/25.
//

struct TokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    
    func toDomain() -> UserToken {
        UserToken(
            accessToken: self.accessToken,
            refreshToken: self.refreshToken
        )
    }
}
