//
//  APIResultObjectDTO.swift
//  LightOn
//
//  Created by 신정욱 on 6/5/25.
//

struct APIResultObjectDTO<ResponseDTO: Decodable>: Decodable {
    let success: Bool
    let response: ResponseDTO?
    let error: APIErrorDTO?
}
