//
//  PerformancesResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//


struct PerformancesResDTO: Decodable {
    let performances: [Performance]
    
    struct Performance: Decodable {
        let id: Int
        let title: String
        let description: String
        let thumbnailImageUrl: String
        let genres: [String]
        let startDate: String  // yyyy-MM-dd
        let startTime: String  // HH:mm:ss
        let isPaid: Bool
        let regionName: String
        
        func toPopular() -> PopularCellItem {
            PopularCellItem(
                performanceID: id,
                thumbnailPath: thumbnailImageUrl,
                title: title,
                date: startDate,
                time: startTime,
                location: regionName
            )
        }
        
        func toRecommend() -> RecommendCellItem {
            RecommendCellItem(
                performanceID: id,
                thumbnailPath: thumbnailImageUrl,
                title: title
            )
        }
    }
}
