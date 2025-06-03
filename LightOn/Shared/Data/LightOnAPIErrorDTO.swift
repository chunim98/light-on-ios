//
//  LightOnAPIErrorDTO.swift
//  LightOn
//
//  Created by 신정욱 on 6/2/25.
//


struct LightOnAPIErrorDTO: Decodable {
    let status: Int
    let message: String
}
