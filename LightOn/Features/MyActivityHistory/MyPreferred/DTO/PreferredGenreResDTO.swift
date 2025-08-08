//
//  PreferredGenreResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 8/7/25.
//

struct PreferredGenreResDTO: Decodable {
    let genres: [GenreDTO]
    
    struct GenreDTO: Decodable {
        let name: String
        let imageUrl: String?
    }
}

// MARK: Mapper

extension PreferredGenreResDTO.GenreDTO {
    func toDomain() -> MyPreferredCellItem {
        /// ``GenreCellItem``에 선언된 타입 변수 데이터 활용
        let genre = GenreCellItem.genres.first { $0.title == self.name }
        
        return MyPreferredCellItem(
            image: genre?.image,
            imagePath: nil,
            title: name
        )
    }
}
