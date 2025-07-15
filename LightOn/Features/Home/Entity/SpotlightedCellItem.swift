//
//  SpotlightedCellItem.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

struct SpotlightedCellItem: Hashable {
    let performanceID: Int
    let thumbnailPath: String?
    let artist: String
    let title: String
    let genre: String
    let date: String
    let time: String
    let location: String

    static let mockItems: [SpotlightedCellItem] = [
        .init(
            performanceID: 0,
            thumbnailPath: nil,
            artist: "라이트온",
            title: "[여의도] Light ON 홀리데이 버스킹",
            genre: "어쿠스틱",
            date: "2025.05.01",
            time: "17:00",
            location: "서울 영등포구 여의도동 81-8"
        ),
        .init(
            performanceID: 0,
            thumbnailPath: nil,
            artist: "문라이트",
            title: "[홍대] Moonlight 감성 어쿠스틱",
            genre: "인디",
            date: "2025.05.03",
            time: "19:30",
            location: "서울 마포구 와우산로21길 19"
        ),
        .init(
            performanceID: 0,
            thumbnailPath: nil,
            artist: "오렌지스푼",
            title: "[강남] Orange Spoon 밤하늘 콘서트",
            genre: "재즈",
            date: "2025.05.05",
            time: "20:00",
            location: "서울 강남구 테헤란로 427"
        ),
        .init(
            performanceID: 0,
            thumbnailPath: nil,
            artist: "버스킹나잇",
            title: "[잠실] Busking Night with Friends",
            genre: "락",
            date: "2025.05.07",
            time: "18:00",
            location: "서울 송파구 올림픽로 240"
        )
    ]
}
