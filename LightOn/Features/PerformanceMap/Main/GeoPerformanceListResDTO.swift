//
//  GeoPerformanceListResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 7/21/25.
//


struct GeoPerformanceListResDTO: Decodable {
    let performanceMapList: [PerformanceMap]
    
    struct PerformanceMap: Decodable {
        let id: Int
        let posterUrl: String
        let title: String
        let artistNames: [String]
        let latitude: Double
        let longitude: Double
        let startDate: String
        let startTime: String
        let endDate: String
        let endTime: String
        let address: String
        let genres: [String]
        
        func toDomain() -> GeoPerformanceInfo {
            let date = startDate.replacingOccurrences(of: "-", with: ".")
            let time = startTime.prefix(5)

            return GeoPerformanceInfo(
                id: id,
                thumbnailPath: posterUrl,
                artist: artistNames.first ?? "알 수 없는 아티스트",
                title: title,
                genre: genres.first ?? "알 수 없는 장르",
                date: date,
                time: String(time),
                location: address,
                latitude: latitude,
                longitude: longitude
            )
        }
    }
}


