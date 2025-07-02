//
//  APIError.swift
//  LightOn
//
//  Created by 신정욱 on 7/3/25.
//

struct APIError: Error {
    let status: Int
    let message: String
}
