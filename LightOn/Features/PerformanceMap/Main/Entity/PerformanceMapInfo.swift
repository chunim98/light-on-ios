//
//  PerformanceMapInfo.swift
//  LightOn
//
//  Created by 신정욱 on 7/22/25.
//

struct PerformanceMapInfo {
    let performanceID: Int
    let thumbnailPath: String?
    let artist: String
    let title: String
    let genre: String
    let date: String
    let time: String
    let location: String
    let latitude: Double
    let longitude: Double
    
    func toCellItem() -> SpotlightedCellItem  {
        SpotlightedCellItem(
            performanceID: performanceID,
            thumbnailPath: thumbnailPath,
            artist: artist,
            title: title,
            genre: genre,
            date: date,
            time: time,
            location: location
        )
    }
    
    func toMarkerInfo() -> MarkerInfo {
        MarkerInfo(
            performaceID: performanceID,
            latitude: latitude,
            longitude: longitude
        )
    }
}
