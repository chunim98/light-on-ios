//
//  LikingGenreRequestDTO.swift
//  LightOn
//
//  Created by 신정욱 on 7/3/25.
//


struct LikingGenreRequestDTO: Encodable {
    let genres: [String]
    
    init(from domain: [GenreCellItem]) {
        self.genres = domain.map { String($0.title) }
    }
}
