//
//  GeoPerformanceInfo.swift
//  LightOn
//
//  Created by 신정욱 on 7/22/25.
//

struct GeoPerformanceInfo {
    let id: Int
    let thumbnailPath: String?
    let artist: String
    let title: String
    let genre: String
    let date: String
    let time: String
    let location: String
    let latitude: Double
    let longitude: Double
    
    func toCellItem() -> MediumPerformanceCellItem  {
        MediumPerformanceCellItem(
            performanceID: id,
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
            performaceID: id,
            latitude: latitude,
            longitude: longitude
        )
    }
}
