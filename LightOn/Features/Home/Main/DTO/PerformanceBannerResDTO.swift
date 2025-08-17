//
//  PerformanceBannerResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 7/23/25.
//

struct PerformanceBannerResDTO: Decodable {
    let advertisements: [Advertisement]

    struct Advertisement: Decodable {
        let id: Int
        let position: Position
        let displayOrder: Int
        let imageUrl: String
        let linkUrl: String
        let title: String
        let content: String
        
        func toDomain() -> PerformanceBannerItem {
            PerformanceBannerItem(
                performanceID: id,
                imagePath: imageUrl,
                title: title,
                description: content
            )
        }
    }
    
    enum Position: String, Decodable {
        case main = "MAIN"
    }
}


