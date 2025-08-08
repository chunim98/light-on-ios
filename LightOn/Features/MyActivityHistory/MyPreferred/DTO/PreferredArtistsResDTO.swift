//
//  PreferredArtistsResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 8/9/25.
//


struct PreferredArtistsResDTO: Decodable {
    let artists: [Artist]

    struct Artist: Decodable {
        let id: Int
        let name: String
        let profileImageUrl: String
    }
}

// MARK: Mapper

extension PreferredArtistsResDTO.Artist {
    func toDomain() -> MyPreferredCellItem {
        MyPreferredCellItem(
            image: nil,
            imagePath: profileImageUrl,
            title: name
        )
    }
}
