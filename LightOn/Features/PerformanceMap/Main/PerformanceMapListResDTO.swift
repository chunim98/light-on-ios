//
//  PerformanceMapListResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 7/21/25.
//


struct PerformanceMapListResDTO: Decodable {
    let performanceMapList: [PerformanceMap]
    
    struct PerformanceMap: Decodable {
        let id: Int
        let posterUrl: String
        let title: String
        let latitude: Double
        let longitude: Double
        let startDate: String
        let endDate: String
        
        func toDomain() -> PerformanceMapInfo {
            let date = startDate.replacingOccurrences(of: "-", with: ".")
//            let startTime = startTime.prefix(5)

            return PerformanceMapInfo(
                performanceID: id,
                thumbnailPath: posterUrl,
                artist: "임시 아티스트",
                title: title,
                genre: "임시 장르",
                date: date,
                time: "00:00",
                location: "임시 주소",
                latitude: latitude,
                longitude: longitude
            )
        }
    }
}


