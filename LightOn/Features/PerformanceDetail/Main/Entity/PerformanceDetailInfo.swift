//
//  PerformanceDetailInfo.swift
//  LightOn
//
//  Created by 신정욱 on 7/16/25.
//

struct PerformanceDetailInfo {
    enum PerformanceType { case concert, busking }
    
    let type: PerformanceType
    let thumbnailPath: String
    let genre: String
    let title: String
    let date: String
    let time: String
    let place: String
    let isPaid: Bool
    let price: String
    let description: String
    let artistName: String
    let artistDescription: String
    let seatDescription: String
    let noticeDescription: String
}
