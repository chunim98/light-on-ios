//
//  ArtistInfoResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 9/6/25.
//

struct ArtistInfoResDTO: Decodable {
    let artistName: String
    let artistDescription: String
}

extension ArtistInfoResDTO {
    func toDomain() -> ArtistInfo {
        ArtistInfo(
            artistName: artistName,
            artistDescription: artistDescription
        )
    }
}
