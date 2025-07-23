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
        let artistName: String
        
        func toLarge() -> LargePerformanceCellItem {
            let startDate = startDate.replacingOccurrences(of: "-", with: ".")
            let startTime = startTime.prefix(5)
            
            return LargePerformanceCellItem(
                performanceID: id,
                thumbnailPath: thumbnailImageUrl,
                title: title,
                date: startDate,
                time: String(startTime),
                location: regionName
            )
        }
        
        func toMedium() -> MediumPerformanceCellItem {
            let startDate = startDate.replacingOccurrences(of: "-", with: ".")
            let startTime = startTime.prefix(5)
            
            return MediumPerformanceCellItem(
                performanceID: id,
                thumbnailPath: thumbnailImageUrl,
                artist: artistName,
                title: title,
                genre: genres.first ?? "알 수 없는 장르",
                date: startDate,
                time: String(startTime),
                location: regionName
            )
        }
        
        func toSmall() -> SmallPerformanceCellItem {
            SmallPerformanceCellItem(
                performanceID: id,
                thumbnailPath: thumbnailImageUrl,
                title: title
            )
        }
        
        /// GenreDiscovery에서 사용됨
        func toHashtag() -> HashtagPerformanceCellItem {
            let startDate = startDate.replacingOccurrences(of: "-", with: ".")
            let startTime = startTime.prefix(5)
            
            return HashtagPerformanceCellItem(
                id: id,
                thumbnailPath: thumbnailImageUrl,
                typeLabelHidden: isPaid,
                hashtag: genres.first ?? "알 수 없는 장르",
                title: title,
                place: regionName,
                date: "\(startDate) \(startTime)"
            )
        }
    }
}
