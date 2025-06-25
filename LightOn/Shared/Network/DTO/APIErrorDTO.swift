//
//  APIErrorDTO.swift
//  LightOn
//
//  Created by 신정욱 on 6/4/25.
//

struct APIErrorDTO: Decodable, Error {
    let status: Int
    let message: String
}
